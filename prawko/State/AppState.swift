//
//  AppState.swift
//  prawko
//
//  Created by Jakub Klentak on 29/05/2023.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published public var loggedIn : Bool = false
}
