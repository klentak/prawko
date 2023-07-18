//
//  WatchlistTask.swift
//  prawko
//
//  Created by Jakub Klentak on 17/04/2023.
//

import Foundation
import SwiftUI
import BackgroundTasks


class WatchlistTask<WatchlistRepository>
where WatchlistRepository: WatchlistRepositoryProtocol {
    private let infoCarRepository: InfoCarRepository
    private let watchlistRepository: WatchlistRepository
    
    init(
        infoCarRepository: InfoCarRepository,
        watchlistRepository: WatchlistRepository
    ) {
        self.infoCarRepository = infoCarRepository
        self.watchlistRepository = watchlistRepository
    }
    
    func refreshAppData() {
        for watchlistElement in watchlistRepository.getList() {
            getNearestExamWithDateBeforeWatchlistElement(watchlistElement: watchlistElement) { result in
                switch result {
                case .failure(_):
                    return
                case .success(let result):
                    if result.exam != nil {
                        UNUserNotificationCenter.current().add(
                            UNNotificationRequest(
                                identifier: self.generateNotificationIdentifier(
                                    watchlistElement: result.watchlistElement!,
                                    exam: result.exam!
                                ),
                                content: self.generateNotification(exam: result.exam!),
                                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
                            )
                        )
                    }
                }
            }
        }
    }
    
    func generateNotification(exam: Exam) -> UNMutableNotificationContent {
        let result = UNMutableNotificationContent()
        
        result.title = "Zwolnił się termin egzaminu!";
        result.subtitle = "Termin: \(formatDate(date: exam.date, formatTo: "dd-MM-yyyy HH:mm"))"
        
        return result
    }
    
    func generateNotificationIdentifier(
        watchlistElement: WatchlistElement,
        exam: Exam
    ) -> String {
        var result = "newExamDate"

        result += "_\(exam.date)"
        result += "_\(watchlistElement.wordId)"
        result += "_\(watchlistElement.category.id)"
        result += "_\(watchlistElement.type.rawValue)"
        
        return result
    }
    
    func getNearestExamWithDateBeforeWatchlistElement(
        watchlistElement: WatchlistElement,
        completion: @escaping (Result<(exam: Exam?, watchlistElement: WatchlistElement?), Error>) -> Void
    ) {
        self.infoCarRepository.getScheduledDays(category: watchlistElement.category, wordId: watchlistElement.wordId) { result in
            switch result {
            case .failure(let exception):
                completion(.failure(exception))
            case .success(let scheduleDayDTOCollection):
                let result = self.getNearestExamWithDateBeforeWatchlistElementFromCollection(
                    scheduleDayDTOCollection: scheduleDayDTOCollection,
                    watchlistElement: watchlistElement
                )
                
                if result != nil {
                    completion(.success((result, watchlistElement)))
                }
            }
        }
        
        completion(.success((nil, nil)))
    }

    func getNearestExamWithDateBeforeWatchlistElementFromCollection(
        scheduleDayDTOCollection: [ScheduleDay],
        watchlistElement: WatchlistElement
    ) -> Exam? {
        for scheduleDTO in scheduleDayDTOCollection {
            for scheduledHoursDTO in scheduleDTO.scheduledHours {
                let exams = (watchlistElement.type == ExamTypeEnum.theory)
                    ? scheduledHoursDTO.theoryExams
                    : scheduledHoursDTO.practiceExams

                for exam in exams {
                    if (
                        watchlistElement.latestExam == nil
                        || exam.date <= watchlistElement.latestExam!.date
                    ) {
                        return exam
                    }
                }
            }
        }

        return nil
    }
}
