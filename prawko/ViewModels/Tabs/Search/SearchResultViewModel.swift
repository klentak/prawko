//
//  SearchResultViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 26/12/2022.
//

import SwiftUI
import Alamofire
import KeychainSwift

class SearchResultViewModel: SearchResultVMProtocol {
    @Published var scheduledDays: [ScheduleDayDTO]
    private var infoCarRepository: InfoCarRepository
    
    init(infoCarRepository: InfoCarRepository) {
        self.scheduledDays = [ScheduleDayDTO]()
        self.infoCarRepository = infoCarRepository
    }
    
    func getScheduledDays(category: DrivingLicenceCategory, wordId: String, completion: @escaping (Bool) -> Void) {
        infoCarRepository.getScheduledDays(category: category, wordId: wordId) { result in
            switch result {
            case .failure(_):
                completion(false)
                return
            case .success(let scheduledDays):
                self.scheduledDays = scheduledDays
                completion(true)
            }
        }
    }
    
    func showDayGroup(scheduleDay: ScheduleDayDTO, examType: ExamTypeEnum) -> Bool {
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
