//
//  NotificationsSettingsAddResultViewModelMock.swift
//  prawko
//
//  Created by Jakub Klentak on 25/06/2023.
//

import Foundation

class NotificationsSettingsAddResultVMMock: ObservableObject, NotificationsSettingsAddResultVMProtocol {
    @Published var exam: Exam?

    init(exam: Exam? = nil) {
        self.exam = exam
    }
    
    func getScheduledDays(category: DrivingLicenceCategory, wordId: String, type: ExamTypeEnum, completion: @escaping (Result<Bool, Error>) -> Void) {
        completion(.success(true));
    }
}
