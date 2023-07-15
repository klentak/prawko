//
//  LoginServiceMock.swift
//  prawko
//
//  Created by Jakub Klentak on 28/06/2023.
//

import Foundation
import SwiftUI

class LoginServiceMock: LoginServiceProtocol {
    @EnvironmentObject var appState: AppState
    
    func logout() {
        appState.loggedIn = false
    }
    
    func actualBearerCode(completion: @escaping (Result<Bool, LoginError>) -> Void) {
        completion(.success(true))
    }
    
    func processLogin(email: String, password: String, completion: @escaping (Result<Bool, LoginError>) -> Void) {
        appState.loggedIn = true
        
        completion(.success(true))
    }
    
    
}
