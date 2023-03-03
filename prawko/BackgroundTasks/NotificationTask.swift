//
//  NotificationTask.swift
//  prawko
//
//  Created by Jakub Klentak on 19/02/2023.
//

import BackgroundTasks
import Alamofire
    
class NotificationTask {
    let infoCarRepository = InfoCarRepository()
    
    func handleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "notification")
        request.earliestBeginDate = .now.addingTimeInterval(5 * 60)
        try? BGTaskScheduler.shared.submit(request)
    }
    
    func handleBackgroundTask(task: BGAppRefreshTask) {
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            for watchlistElement in WatchlistRepository.shared.getList() {
                self.infoCarRepository.getScheduledDays(category: watchlistElement.category, wordId: watchlistElement.wordId) { result in
                    switch result {
                    case .failure(_):
                        return
                    case .success(let scheduleDayDTOCollection):
                        let examWithClosestDate  = self.getNearestExamWithDateBeforeWatchlistElementFromCollection(
                            scheduleDayDTOCollection: scheduleDayDTOCollection,
                            watchlistElement: watchlistElement
                        )
                    }
                }
            }
            
            task.setTaskCompleted(success: true)
        }
        
        scheduleBackgroundTask()
    }
    
    func getNearestExamWithDateBeforeWatchlistElementFromCollection(
        scheduleDayDTOCollection: [ScheduleDayDTO],
        watchlistElement: WatchlistElement
    ) -> ExamDTO? {
        for scheduleDTO in scheduleDayDTOCollection {
            for scheduledHoursDTO in scheduleDTO.scheduledHours {
                let exams = (watchlistElement.type == ExamTypeEnum.theory)
                    ? scheduledHoursDTO.theoryExams
                    : scheduledHoursDTO.practiceExams
                
                for exam in exams {
                    if (
                        watchlistElement.latestExam == nil
                        || exam.date <= watchlistElement.latestExam!.date
                    ) {
                        return exam
                    }
                }
            }
        }
        
        return nil
    }
    
    func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.myapp.backgroundtask")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 300) // Wykonaj co 5 minut
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Nie udało się zaplanować wykonywania strzału: \(error.localizedDescription)")
        }
    }
}
