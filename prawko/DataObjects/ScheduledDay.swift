//
//  ScheduledDaysDTO.swift
//  prawko
//
//  Created by Jakub Klentak on 24/12/2022.
//

import Foundation

public struct Root : Decodable, Hashable {
    public let schedule : Schedule
    
    private enum CodableKeys: String, CodingKey {
        case schedule
    }
}

public struct Schedule : Decodable, Hashable {
    public let scheduledDays : [ScheduleDay]
}

public struct ScheduleDay : Decodable, Hashable, Identifiable {
    public var id = UUID()
    
    public let day : String
    public let scheduledHours : [ScheduledHours]
    
    private enum CodingKeys: String, CodingKey {
        case day
        case scheduledHours
    }
}

public struct ScheduledHours : Decodable, Hashable, Identifiable {
    public var id = UUID()
    
    public let practiceExams : [Exam]
    public let theoryExams : [Exam]
    public let time : String
    
    private enum CodingKeys: String, CodingKey {
        case practiceExams
        case theoryExams
        case time
    }
}

public struct Exam : Decodable, Hashable, Identifiable, Encodable {
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
