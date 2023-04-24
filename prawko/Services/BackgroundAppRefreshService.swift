//
//  BackgroundAppRefreshService.swift
//  prawko
//
//  Created by Jakub Klentak on 15/04/2023.
//

import Foundation
import BackgroundTasks

class BackgroundAppRefresherService : ObservableObject {
    static let shared = BackgroundAppRefresherService()
    
    public func scheduleNotifications() -> Void {
        let request = BGAppRefreshTaskRequest(identifier: "wishlistNotification")
        request.earliestBeginDate = Calendar.current.date(byAdding: .minute, value: 10, to: Date())

        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background Task Scheduled!")
        } catch(let error) {
            print("Scheduling Error \(error.localizedDescription)")
        }
    }
}
