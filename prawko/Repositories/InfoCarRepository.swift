//
//  InfoCarRepository.swift
//  prawko
//
//  Created by Jakub Klentak on 30/03/2023.
//

import Foundation
import Alamofire

class InfoCarRepository {

    func getScheduledDays(
        category: DrivingLicenceCategory,
        wordId: String,
        completion: @escaping (Result<[ScheduleDayDTO], Error>) -> Void
    ) {
        var dateComponent = DateComponents()
        dateComponent.month = 1

        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: dateComponent, to: Date())!

        APIManager.session.request(
            UrlConst.mainUrl + UrlConst.examSchedule,
            method: .put,
            parameters: [
                "category": category.name,
                "endDate": startDate.description,
                "startDate": endDate.description,
                "wordId": wordId,
            ],
            encoding: JSONEncoding()
        ).responseDecodable(of: Root.self) { response in
            // TODO: obsługa błędów
            guard let result = response.value else {
                completion(.failure(ApiConectionError.parseData("Błędna odpowiedź z serwisu info-share!")))
                return
            }

            completion(.success(result.schedule.scheduledDays))
        }
    }
}
