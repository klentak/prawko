//
//  LoginVMProtocol.swift
//  prawko
//
//  Created by Jakub Klentak on 28/06/2023.
//

import Foundation

protocol LoginVMProtocol: ObservableObject {
    var email: String { get set }
    var password: String { get set }
    var wrongLoginData: Bool { get set }
    var unexpectedError: Bool { get set }
    var loading: Bool { get }
    
    var loginService: any LoginServiceProtocol { get }
    
    func login() -> Void
}
