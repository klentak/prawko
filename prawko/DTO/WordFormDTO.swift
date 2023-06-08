//
//  WordFormDTO.swift
//  prawko
//
//  Created by Jakub Klentak on 07/06/2023.
//

import Foundation

struct WordFormDTO: Identifiable {
    let id = UUID()
    var selectedWord: Word?
    var selectedProvince: Province?
    var selectedDrivingCategory: DrivingLicenceCategory?
    var selectedExamType: ExamTypeEnum
}

