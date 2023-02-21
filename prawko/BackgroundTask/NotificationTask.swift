//
//  NotificationTask.swift
//  prawko
//
//  Created by Jakub Klentak on 19/02/2023.
//

import BackgroundTasks
    
func notification() {
    let request = BGAppRefreshTaskRequest(identifier: "notification")
    request.earliestBeginDate = .now.addingTimeInterval(5 * 60)
    try? BGTaskScheduler.shared.submit(request)
}
