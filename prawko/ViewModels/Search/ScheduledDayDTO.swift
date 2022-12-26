//
//  ScheduledDaysDTO.swift
//  prawko
//
//  Created by Jakub Klentak on 24/12/2022.
//

import Foundation

public struct Root : Decodable, Hashable {
    public let schedule : ScheduleDTO
}

public struct ScheduleDTO : Decodable, Hashable {
    public let scheduledDays : [ScheduleDayDTO]
}

public struct ScheduleDayDTO : Decodable, Hashable {
    public let day : String
    public let scheduledHours : [ScheduledHoursDTO]
}

public struct ScheduledHoursDTO : Decodable, Hashable {
    public let practiceExams : [ExamDTO]
    public let theoryExams : [ExamDTO]
    public let time : String
}

public struct ExamDTO : Decodable, Hashable {
    public let additionalInfo : String
    public let amount : Int
    public let date : String
    public let id : String
    public let places : Int
}
