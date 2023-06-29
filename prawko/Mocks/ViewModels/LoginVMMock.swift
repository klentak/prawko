//
//  LoginVMMock.swift
//  prawko
//
//  Created by Jakub Klentak on 28/06/2023.
//

import Foundation

class LoginVMMock: LoginVMProtocol {
    var loginService: any LoginServiceProtocol
    
    var email: String = ""
    var password: String = ""
    var wrongLoginData: Bool
    var unexpectedError: Bool
    var loading: Bool
    
    init(loginService: any LoginServiceProtocol) {
        self.email = ""
        self.password = ""
        self.wrongLoginData = false
        self.unexpectedError = false
        self.loading = false
        self.loginService = loginService
    }
    
    func login() {}
}
