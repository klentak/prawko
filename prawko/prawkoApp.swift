//
//  prawkoApp.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI

@main
struct prawkoApp: App {
    let watchlistTask : WatchlistTask = WatchlistTask()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .backgroundTask(.appRefresh("wishlistNotification")) {
            watchlistTask.refreshAppData()
        }
    }
}
