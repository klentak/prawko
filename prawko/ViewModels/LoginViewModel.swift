//
//  LoginViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 28/05/2023.
//

import Foundation


class LoginViewModel : ObservableObject {
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var wrongLoginData: Bool = false
    @Published public var unexpectedError: Bool = false
    @Published private(set) var loading: Bool = false
    
    private let loginService = LoginService()

    public func login() -> Void {
        self.loading = true
        loginService.processLogin(email: email, password: password) { result in
            switch result {
            case .failure(let failure):
                switch failure {
                case LoginError.wrongLoginData:
                    self.wrongLoginData = true
                    self.password = ""
                default:
                    self.unexpectedError = true
                }
            default:
                print(1)
            }
            self.loading = false
        }
    }
}
