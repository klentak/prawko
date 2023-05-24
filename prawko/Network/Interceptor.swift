//
//  RequestInterceptor.swift
//  prawko
//
//  Created by Jakub Klentak on 23/05/2023.
//

import Foundation
import Alamofire
import KeychainSwift

class Interceptor: RequestInterceptor {
    let retryLimit = 5

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        let response = request.task?.response as? HTTPURLResponse
        if let statusCode = response?.statusCode,
            statusCode == 401,
            request.retryCount < retryLimit
        {
            LoginService.shared.actualBearerCode() { loginResult in
                switch loginResult {
                case .failure(_):
                    completion(.doNotRetry)
                    
                    return
                case .success:
                    completion(.retry)
                }
            }
        } else {
            print("trzy")
            return completion(.doNotRetry)
        }
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let keyChain = KeychainSwift()
        var urlRequest = urlRequest

        urlRequest.setValue("Bearer " + keyChain.get("bearer")!, forHTTPHeaderField: "Authorization")
        
        completion(.success(urlRequest))
    }
}

