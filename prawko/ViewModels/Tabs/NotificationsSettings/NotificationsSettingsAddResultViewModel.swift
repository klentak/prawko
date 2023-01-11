//
//  NotificationsSettingsViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 08/01/2023.
//

import Alamofire
import KeychainSwift


class NotificationsSettingsAddResultViewModel : ObservableObject {
    @Published var exam: ExamDTO? = nil
    
    private var userDefaults = UserDefaults.standard
    
    public func getScheduledDays(
        category: DrivingLicenceCategory,
        wordId: String,
        type: ExamTypeEnum,
        completion: @escaping (Bool) -> Void
    ) {
        var dateComponent = DateComponents()
        dateComponent.month = 1

        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: dateComponent, to: Date())!
        
        let keyChain = KeychainSwift()
        
        var headers = HTTPHeaders.default
        headers.add(HTTPHeader(
            name: "Authorization",
            value: "Bearer " + keyChain.get("bearer")!
        ))
        
        AF.request(
            UrlConst.mainUrl + UrlConst.examSchedule,
            method: .put,
            parameters: [
                "category": category.name,
                "endDate": startDate.description,
                "startDate": endDate.description,
                "wordId": wordId,
            ],
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: Root.self) { response in
            if (response.response?.statusCode == 401) {
                let loginViewModel = LoginViewModel()
                
                loginViewModel.actualBearerCode() { _ in
                    self.getScheduledDays(category: category, wordId: wordId, type: type, completion: completion)
                }
            }
            
            // TODO: obsługa błędów
            guard let result = response.value else {
                completion(false)
                return
            }
            
            switch type {
            case .practice:
                self.exam = result.schedule.scheduledDays.first?.scheduledHours.first?.practiceExams.first
                
                self.addToUserDefaults(category: category, wordId: wordId, latestExam: self.exam, type: type)
            case .theory:
                self.exam = result.schedule.scheduledDays.first?.scheduledHours.first?.theoryExams.first
                
                self.addToUserDefaults(category: category, wordId: wordId, latestExam: self.exam, type: type)
            case .none:
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    private func addToUserDefaults(category: DrivingLicenceCategory, wordId: String, latestExam: ExamDTO?, type: ExamTypeEnum) {
        let newWatchlistElement = WatchlistElement(category: category, wordId: wordId, type: type, latestExam: latestExam)
        
        WatchlistRepository.addElement(newWatchlistElement)
    }
}
