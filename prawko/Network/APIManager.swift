//
//  APIManager.swift
//  prawko
//
//  Created by Jakub Klentak on 23/05/2023.
//

import Foundation
import Alamofire

class APIManager {
    public let session: Session

    init(interceptor: Interceptor) {
        session = {
            let configuration = URLSessionConfiguration.af.default
            
            return Session(
              configuration: configuration,
              interceptor: interceptor
            )
        }()
    }
}
