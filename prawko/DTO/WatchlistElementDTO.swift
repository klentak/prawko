//
//  WatchlistElementDTO.swift
//  prawko
//
//  Created by Jakub Klentak on 09/01/2023.
//

import Foundation

public struct WatchlistElement: Hashable, Identifiable, Decodable, Encodable {
    public var id = UUID()
    
    let category : DrivingLicenceCategory
    let wordId : String
    let type : ExamTypeEnum
    let latestExam: ExamDTO?
}
