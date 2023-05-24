//
//  APIManager.swift
//  prawko
//
//  Created by Jakub Klentak on 23/05/2023.
//

import Foundation
import Alamofire

class APIManager {
    static let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        
        return Session(
          configuration: configuration,
          interceptor: Interceptor()
        )
    }()
}
