//
//  NotificationsSettingsViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 08/01/2023.
//

import SwiftUI
import Alamofire

class NotificationsSettingsAddResultViewModel<WatchlistRepository>: NotificationsSettingsAddResultVMProtocol
where WatchlistRepository: WatchlistRepositoryProtocol {
    @Published var exam: ExamDTO? = nil
    private var userDefaults = UserDefaults.standard
    private let apiManager: APIManager
    private let watchlistRepository: WatchlistRepository
    @StateObject private var appState: AppState
    
    init(
        apiManager: APIManager,
        watchlistRepository: WatchlistRepository,
        appState: AppState
    ) {
        self.apiManager = apiManager
        self.watchlistRepository = watchlistRepository
        self._appState = StateObject(wrappedValue: appState)
    }
    
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
        
        apiManager.session.request(
            UrlConst.mainUrl + UrlConst.examSchedule,
            method: .put,
            parameters: [
                "category": category.name,
                "endDate": startDate.description,
                "startDate": endDate.description,
                "wordId": wordId,
            ],
            encoding: JSONEncoding.default
        ).responseDecodable(of: Root.self) { response in
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
        
        try watchlistRepository.addElement(newWatchlistElement)

        appState.watchlistElements = watchlistRepository.getList()
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
