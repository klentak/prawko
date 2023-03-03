//
//  prawkoApp.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI
import BackgroundTasks

@main
struct prawkoApp: App {
    @Environment(\.scenePhase) private var phase
    
    private var notificationTask = NotificationTask()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        registerBackgroundTask()
    }
        
    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: UUID().uuidString, using: nil) { task in
            notificationTask.handleBackgroundTask(task: task as! BGAppRefreshTask)
        }
    }
}
