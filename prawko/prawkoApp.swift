//
//  prawkoApp.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI
import Foundation

@main
struct prawkoApp: App {
    let watchlistTask: WatchlistTask
    
    init() {
        self.watchlistTask = CompositionRoot.watchlistTask
    }
    
    var body: some Scene {
        WindowGroup {
            CompositionRoot.contentView
        }
        .backgroundTask(.appRefresh("wishlistNotification")) {
            watchlistTask.refreshAppData()
        }
    }
}
