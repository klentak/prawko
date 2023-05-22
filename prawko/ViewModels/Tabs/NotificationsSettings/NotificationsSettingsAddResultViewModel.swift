//
//  NotificationsSettingsViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 08/01/2023.
//

import SwiftUI
import Alamofire
import KeychainSwift

class NotificationsSettingsAddResultViewModel : ObservableObject {
    @Published var exam: ExamDTO? = nil
    
    private var userDefaults = UserDefaults.standard
    
    public func getScheduledDays(
        category: DrivingLicenceCategory,
        wordId: String,
        type: ExamTypeEnum,
        completion: @escaping (Result<Bool, Error>) -> Void
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
                    case .failure(let exception):
                        completion(.failure(exception))
                        return
                    case .success:
                        self.getScheduledDays(category: category, wordId: wordId, type: type, completion: completion)
                    }
                }
            }
            
            switch response.result {
            case .failure(let error):
                completion(.failure(error))
                return
            case .success(let result):
                self.saveResponse(
                    result: result,
                    category: category,
                    wordId: wordId,
                    type: type,
                    completion: completion
                )
            }
        }
    }
    
    public func showErrorAlert(view: NotificationsSettingsAddResultView, error: Error) {
        
    }
    
    private func addToUserDefaults(
        category: DrivingLicenceCategory,
        wordId: String,
        latestExam: ExamDTO?,
        type: ExamTypeEnum
    ) throws {
        let newWatchlistElement = WatchlistElement(
            category: category,
            wordId: wordId,
            type: type,
            latestExam: latestExam
        )
        
        try WatchlistRepository.shared.addElement(newWatchlistElement)
    }
    
    private func saveResponse(
        result: Root,
        category: DrivingLicenceCategory,
        wordId: String,
        type: ExamTypeEnum,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        switch type {
        case .practice:
            for scheduledDay in result.schedule.scheduledDays {
                for scheduledHour in scheduledDay.scheduledHours {
                    if (!scheduledHour.practiceExams.isEmpty) {
                        self.exam = scheduledHour.practiceExams.first!
                        do {
                            try self.addToUserDefaults(
                                category: category,
                                wordId: wordId,
                                latestExam: nil,
                                type: type
                            )
                        } catch (let exception) {
                            completion(.failure(exception))
                            return
                        }
                        completion(.success(true))
                        return
                    }
                }
            }
        case .theory:
            for scheduledDay in result.schedule.scheduledDays {
                for scheduledHour in scheduledDay.scheduledHours {
                    if (!scheduledHour.theoryExams.isEmpty) {
                        self.exam = scheduledHour.theoryExams.first!
                        do {
                            try self.addToUserDefaults(
                                category: category,
                                wordId: wordId,
                                latestExam: nil,
                                type: type
                            )
                        } catch (let exception) {
                            completion(.failure(exception))
                            return
                        }
                        completion(.success(true))
                        return
                    }
                }
            }
        case .none:
            completion(.success(true))
            return
        }
    }
}
