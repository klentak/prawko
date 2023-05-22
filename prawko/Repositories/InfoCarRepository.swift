//
//  InfoCarRepository.swift
//  prawko
//
//  Created by Jakub Klentak on 30/03/2023.
//

import Foundation
import Alamofire
import KeychainSwift

class InfoCarRepository {
    private var keyChain = KeychainSwift()

    func getScheduledDays(
        category: DrivingLicenceCategory,
        wordId: String,
        completion: @escaping (Result<[ScheduleDayDTO], Error>) -> Void
    ) {
        var dateComponent = DateComponents()
        dateComponent.month = 1

        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: dateComponent, to: Date())!

        var headers = HTTPHeaders()

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
            encoding: JSONEncoding(),
            headers: headers
        ).responseDecodable(of: Root.self) { response in
            if (response.response?.statusCode == 401) {
                LoginService.shared.actualBearerCode() { loginResult in
                    switch loginResult {
                    case .failure(let error):
                        completion(.failure(error))

                        return
                    case .success:
                        self.getScheduledDays(category: category, wordId: wordId, completion: completion)
                        return
                    }
                }
            }

            // TODO: obsługa błędów
            guard let result = response.value else {
                completion(.failure(ApiConectionError.parseData("Błędna odpowiedź z serwisu info-share!")))
                return
            }

            completion(.success(result.schedule.scheduledDays))
        }
    }
}
