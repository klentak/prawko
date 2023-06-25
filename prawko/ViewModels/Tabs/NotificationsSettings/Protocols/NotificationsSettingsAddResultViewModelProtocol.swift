//
//  NotificationsSettingsAddResultViewModelProtocol.swift
//  prawko
//
//  Created by Jakub Klentak on 24/06/2023.
//

import Foundation

protocol NotificationsSettingsAddResultViewModelProtocol: ObservableObject {
    var exam: ExamDTO? { get }
    
    func getScheduledDays(
        category: DrivingLicenceCategory,
        wordId: String,
        type: ExamTypeEnum,
        completion: @escaping (Result<Bool, Error>) -> Void
    );
}
