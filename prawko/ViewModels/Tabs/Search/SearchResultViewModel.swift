//
//  SearchResultViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 26/12/2022.
//

import SwiftUI
import Alamofire
import KeychainSwift

class SearchResultViewModel : ObservableObject {
    @Published var scheduledDays: [ScheduleDayDTO] = [ScheduleDayDTO]()
    
    func getScheduledDays(category: DrivingLicenceCategory, wordId: String, completion: @escaping (Bool) -> Void) {
        var dateComponent = DateComponents()
        dateComponent.month = 1

        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: dateComponent, to: Date())!
        
        let keyChain = KeychainSwift()
        var headers = HTTPHeaders.default
        
        headers.add(HTTPHeader(
            name: "Authorization",
            value: "Bearer " + keyChain.get("bearer")!
        ))
        
        AF.request(
            UrlConst.mainUrl + UrlConst.examSchedule,
            method: .put,
            parameters: [
                "category": category.name,
                "endDate": startDate.description,
                "startDate": endDate.description,
                "wordId": wordId,
            ],
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: Root.self) { response in
            if (response.response?.statusCode == 401) {
                let loginViewModel = LoginViewModel()
                
                loginViewModel.actualBearerCode() { loginResult in
                    switch loginResult {
                    case .failure(let encodingError):
                        completion(false)
                        return
                    case .success:
                        return self.getScheduledDays(category: category, wordId: wordId, completion: completion)
                    }
                }
            }
            
            // TODO: obsługa błędów
            guard let result = response.value else {
                completion(false)
                return
            }
            self.scheduledDays = result.schedule.scheduledDays
            completion(true)
        }
    }
    
    func showGroup(scheduleDay: ScheduleDayDTO, examType: ExamTypeEnum) -> Bool {
        switch examType {
        case .theory:
           for scheduledHour in scheduleDay.scheduledHours {
               if (!scheduledHour.theoryExams.isEmpty) {
                   return true
               }
            }
        case .practice:
            for scheduledHour in scheduleDay.scheduledHours {
                if (!scheduledHour.practiceExams.isEmpty) {
                    return true
                }
             }
        case .none:
            for scheduledHour in scheduleDay.scheduledHours {
                if (
                    !scheduledHour.theoryExams.isEmpty
                    && !scheduledHour.practiceExams.isEmpty
                ) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func noResultsByExamType(examType: ExamTypeEnum) -> Bool {
        for scheduleDay in scheduledDays {
            switch examType {
            case .theory:
                for scheduledHour in scheduleDay.scheduledHours {
                    if (!scheduledHour.theoryExams.isEmpty) {
                        return false
                    }
                }
            case .practice:
                for scheduledHour in scheduleDay.scheduledHours {
                    if (!scheduledHour.practiceExams.isEmpty) {
                        return false
                    }
                }
            case .none:
                for scheduledHour in scheduleDay.scheduledHours {
                    if (
                        !scheduledHour.practiceExams.isEmpty
                        || !scheduledHour.theoryExams.isEmpty
                    ) {
                        return false
                    }
                }
            }
        }
        
        return true
    }
}
