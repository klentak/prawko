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
                return LoginService.shared.actualBearerCode() { loginResult in
                    switch loginResult {
                    case .failure:
                        completion(false)
                        return
                    case .success:
                        self.getScheduledDays(category: category, wordId: wordId, type: type, completion: completion)
                    }
                }
            }
            
            // TODO: obsługa błędów
            guard let result = response.value else {
                completion(false)
                return
            }
            
            switch type {
            case .practice:
                for scheduledDay in result.schedule.scheduledDays {
                    for scheduledHour in scheduledDay.scheduledHours {
                        if (!scheduledHour.practiceExams.isEmpty) {
                            self.exam = scheduledHour.practiceExams.first!
                            self.addToUserDefaults(category: category, wordId: wordId, latestExam: self.exam, type: type)
                            completion(true)
                            return
                        }
                    }
                }
            case .theory:
                for scheduledDay in result.schedule.scheduledDays {
                    for scheduledHour in scheduledDay.scheduledHours {
                        if (!scheduledHour.theoryExams.isEmpty) {
                            self.exam = scheduledHour.theoryExams.first!
                            self.addToUserDefaults(category: category, wordId: wordId, latestExam: self.exam, type: type)
                            completion(true)
                            return
                        }
                    }
                }
            case .none:
                completion(false)
                return
            }
        }
    }
    
    private func addToUserDefaults(category: DrivingLicenceCategory, wordId: String, latestExam: ExamDTO?, type: ExamTypeEnum) {
        let newWatchlistElement = WatchlistElement(category: category, wordId: wordId, type: type, latestExam: latestExam)
        
        WatchlistRepository.shared.addElement(newWatchlistElement)
    }
}
