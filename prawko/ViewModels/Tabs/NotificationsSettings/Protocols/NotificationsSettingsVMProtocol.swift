//
//  NotificationsSettingsVMProtocol.swift
//  prawko
//
//  Created by Jakub Klentak on 25/06/2023.
//

import Foundation

protocol NotificationsSettingsVMProtocol: ObservableObject {
    var words: [Word] { get }
    
    var appState: AppState { get }
    
    func getProviences(completion: @escaping (Bool) -> Void)
    
    func getWordById(wordId: String) -> Word?
    
    func setAllowNotifications()
    
    func isNotificationsEnabled(completion: @escaping (Bool) -> Void) -> Void
    
    func removeElementFromWatchlist(offsets: IndexSet)
}
