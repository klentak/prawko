//
//  WatchlistTask.swift
//  prawko
//
//  Created by Jakub Klentak on 17/04/2023.
//

import Foundation
import SwiftUI
import BackgroundTasks


class WatchlistTask {
    private let infoCarRepository = InfoCarRepository()
    
    func refreshAppData() {
        for watchlistElement in WatchlistRepository.shared.getList() {
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
    
    func generateNotification(exam: ExamDTO) -> UNMutableNotificationContent {
        var result = UNMutableNotificationContent()
        
        result.title = "Zwolnił się termin egzaminu!";
        result.subtitle = "Termin: \(formatDate(date: exam.date, formatTo: "dd-MM-yyyy HH:mm"))"
        
        return result
    }
    
    func generateNotificationIdentifier(
        watchlistElement: WatchlistElement,
        exam: ExamDTO
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
        completion: @escaping (Result<(exam: ExamDTO?, watchlistElement: WatchlistElement?), ApiConectionError>) -> Void
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
        scheduleDayDTOCollection: [ScheduleDayDTO],
        watchlistElement: WatchlistElement
    ) -> ExamDTO? {
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
