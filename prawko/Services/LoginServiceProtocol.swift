//
//  LoginServiceProtocol.swift
//  prawko
//
//  Created by Jakub Klentak on 28/06/2023.
//

import Foundation

protocol LoginServiceProtocol: ObservableObject {
    var appState: AppState { get }

    func logout()
    
    func actualBearerCode(completion: @escaping (Result<Bool, LoginError>) -> Void)
    
    func processLogin(email: String, password: String, completion: @escaping (Result<Bool, LoginError>) -> Void)
}
