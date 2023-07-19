//
//  SearchResultVMMockWithError.swift
//  prawko
//
//  Created by Jakub Klentak on 19/07/2023.
//

import Foundation


class SearchResultVMMockWithError: SearchResultVMProtocol {
    @Published var scheduledDays: [ScheduleDay]
    
    init(scheduledDays: [ScheduleDay]) {
        self.scheduledDays = scheduledDays
    }

    func getScheduledDays(category: DrivingLicenceCategory, wordId: String, completion: @escaping (Bool) -> Void) {
        completion(false)
    }
    
    func showDayGroup(scheduleDay: ScheduleDay, examType: ExamTypeEnum) -> Bool {
        switch examType {
        case .theory:
           for scheduledHour in scheduleDay.scheduledHours {
               if (!scheduledHour.theoryExams.isEmpty) {
                   return true
               }
            }
        case .practice:
            for scheduledHour in scheduleDay.scheduledHours {
                if (!scheduledHour.practiceExams.isEmpty) {
                    return true
                }
             }
        case .none:
            for scheduledHour in scheduleDay.scheduledHours {
                if (
                    !scheduledHour.theoryExams.isEmpty
                    || !scheduledHour.practiceExams.isEmpty
                ) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func noResultsByExamType(examType: ExamTypeEnum) -> Bool {
        for scheduleDay in scheduledDays {
            switch examType {
            case .theory:
                for scheduledHour in scheduleDay.scheduledHours {
                    if (!scheduledHour.theoryExams.isEmpty) {
                        return false
                    }
                }
            case .practice:
                for scheduledHour in scheduleDay.scheduledHours {
                    if (!scheduledHour.practiceExams.isEmpty) {
                        return false
                    }
                }
            case .none:
                for scheduledHour in scheduleDay.scheduledHours {
                    if (
                        !scheduledHour.practiceExams.isEmpty
                        && !scheduledHour.theoryExams.isEmpty
                    ) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
}
