//
//  NotificationsSettingsVMProtocol.swift
//  prawko
//
//  Created by Jakub Klentak on 25/06/2023.
//

import Foundation

protocol NotificationsSettingsVMProtocol: ObservableObject {
    var watchlistElements: [WatchlistElement] { get }

    var words: [Word] { get }
    
    func getProviences(completion: @escaping (Bool) -> Void)
    
    func getWordById(wordId: String) -> Word?
    
    func setAllowNotifications()
    
    func isNotificationsEnabled(completion: @escaping (Bool) -> Void) -> Void
    
    func removeElementFromWatchlist(offsets: IndexSet)
}
