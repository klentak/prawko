//
//  ExamTypeEnum.swift
//  prawko
//
//  Created by Jakub Klentak on 04/01/2023.
//

enum ExamTypeEnum: String, CaseIterable, Identifiable, Codable {
    case none = "wszystkie"
    case theory = "teoria"
    case practice = "praktyka"
    
    var id: String { self.rawValue }
}
