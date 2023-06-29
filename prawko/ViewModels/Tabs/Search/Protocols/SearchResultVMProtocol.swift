//
//  SearchResultVMProtocol.swift
//  prawko
//
//  Created by Jakub Klentak on 26/06/2023.
//

import Foundation

protocol SearchResultVMProtocol: ObservableObject {
    var scheduledDays: [ScheduleDayDTO] { get }
    
    func getScheduledDays(category: DrivingLicenceCategory, wordId: String, completion: @escaping (Bool) -> Void)
    
    func showDayGroup(scheduleDay: ScheduleDayDTO, examType: ExamTypeEnum) -> Bool
    
    func noResultsByExamType(examType: ExamTypeEnum) -> Bool
}
