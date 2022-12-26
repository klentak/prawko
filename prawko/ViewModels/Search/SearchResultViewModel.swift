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
    
    func getScheduledDays(category: String, startDate: String, endDate: String, wordId: String) {
        var keyChain = KeychainSwift()
        
        let headers : HTTPHeaders = [
            "Authorization": "Bearer " + keyChain.get("bearer")!,
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        AF.request(
            UrlConst.mainUrl + UrlConst.examSchedule,
            method: .put,
            parameters: [
                "category": category,
                "endDate": startDate,
                "startDate": endDate,
                "wordId": wordId,
            ],
            headers: headers
        ).responseDecodable(of: Root.self) { response in
            if (response.response?.statusCode == 401) {
                let loginViewModel = LoginViewModel()
        
                loginViewModel.actualBearerCode() { completion in
                    self.getScheduledDays(category: category, startDate: startDate, endDate: endDate, wordId: wordId)
                }
            }
            guard let result = response.value else { return }
            print(result.schedule.scheduledDays)
            self.scheduledDays = result.schedule.scheduledDays
        }
    }
}
