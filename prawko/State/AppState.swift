//
//  AppState.swift
//  prawko
//
//  Created by Jakub Klentak on 29/05/2023.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @State static var shared = AppState()

    private init() {}
    
    @Published public var loggedIn : Bool = false
}
