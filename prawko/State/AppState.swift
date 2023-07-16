//
//  AppState.swift
//  prawko
//
//  Created by Jakub Klentak on 29/05/2023.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published public var loggedIn : Bool
    @Published var watchlistElements: [WatchlistElement]

    init(loggedIn: Bool) {
        self.loggedIn = loggedIn
        self.watchlistElements = []
    }
}
