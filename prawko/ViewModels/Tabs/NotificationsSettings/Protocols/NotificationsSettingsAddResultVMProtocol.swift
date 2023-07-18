//
//  NotificationsSettingsAddResultViewModelProtocol.swift
//  prawko
//
//  Created by Jakub Klentak on 24/06/2023.
//

import Foundation

protocol NotificationsSettingsAddResultVMProtocol: ObservableObject {
    var exam: Exam? { get }
    
    func getScheduledDays(
        category: DrivingLicenceCategory,
        wordId: String,
        type: ExamTypeEnum,
        completion: @escaping (Result<Bool, Error>) -> Void
    )
}
