//
//  ScheduledDaysDTO.swift
//  prawko
//
//  Created by Jakub Klentak on 24/12/2022.
//

import Foundation

public struct Root : Decodable, Hashable {
    public let schedule : ScheduleDTO
    
    private enum CodableKeys: String, CodingKey {
        case schedule
    }
}

public struct ScheduleDTO : Decodable, Hashable {
    public let scheduledDays : [ScheduleDayDTO]
}

public struct ScheduleDayDTO : Decodable, Hashable, Identifiable {
    public var id = UUID()
    
    public let day : String
    public let scheduledHours : [ScheduledHoursDTO]
    
    private enum CodingKeys: String, CodingKey {
        case day
        case scheduledHours
    }
}

public struct ScheduledHoursDTO : Decodable, Hashable, Identifiable {
    public var id = UUID()
    
    public let practiceExams : [ExamDTO]
    public let theoryExams : [ExamDTO]
    public let time : String
    
    private enum CodingKeys: String, CodingKey {
        case practiceExams
        case theoryExams
        case time
    }
}

public struct ExamDTO : Decodable, Hashable, Identifiable {
    public var id = UUID()

    public let additionalInfo : String?
    public let amount : Int
    public let date : String
    public let places : Int
    
    private enum CodingKeys: String, CodingKey {
        case additionalInfo
        case amount
        case date
        case places
    }
}
