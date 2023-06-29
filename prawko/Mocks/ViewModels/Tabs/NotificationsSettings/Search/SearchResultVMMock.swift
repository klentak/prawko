//
//  SearchResultVMMock.swift
//  prawko
//
//  Created by Jakub Klentak on 26/06/2023.
//

import Foundation

class SearchResultVMMock: SearchResultVMProtocol {
    @Published var scheduledDays: [ScheduleDayDTO]
    
    init(scheduledDays: [ScheduleDayDTO]) {
        self.scheduledDays = scheduledDays
    }

    func getScheduledDays(category: DrivingLicenceCategory, wordId: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    func showDayGroup(scheduleDay: ScheduleDayDTO, examType: ExamTypeEnum) -> Bool {
        return true
    }
    
    func noResultsByExamType(examType: ExamTypeEnum) -> Bool {
        return true
    }
}
