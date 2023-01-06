//
//  ExamTypeEnum.swift
//  prawko
//
//  Created by Jakub Klentak on 04/01/2023.
//

enum ExamTypeEnum: String, CaseIterable, Identifiable  {
    case none = "-"
    case theory = "teoria"
    case practice = "praktyka"
    
    var id: String { self.rawValue }
}
