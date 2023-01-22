//
//  UserInformationsViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 22/01/2023.
//

import Foundation
import KeychainSwift

class UserInformationsViewModel : ObservableObject {
    private var keychain: KeychainSwift = KeychainSwift()
    
    func Logout() {
        keychain.clear()
    }
}
