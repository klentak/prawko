//
//  NotificationsSettingsViewModelMock.swift
//  prawko
//
//  Created by Jakub Klentak on 25/06/2023.
//

import Foundation
import SwiftUI

class NotificationsSettingsVMMock: NotificationsSettingsVMProtocol {
    @StateObject var appState: AppState
    
    @Published var words: [Word]
    
    var notificationsEnabled: Bool
    
    init(words: [Word], notificationsEnabled: Bool, appState: AppState) {
        self.words = words
        self.notificationsEnabled = notificationsEnabled
        self._appState = StateObject(wrappedValue: appState)
    }
    
    func getWords(completion: @escaping  (ApiConectionError?) -> Void) {
        completion(nil);
    }
    
    func getWordById(wordId: String) -> Word? {
        return Word(
            id: 1,
            name: "Test",
            provinceId: 1
        );
    }
    
    func setAllowNotifications() {
    }
    
    func isNotificationsEnabled(completion: @escaping (Bool) -> Void) {
        completion(self.notificationsEnabled);
    }
    
    func removeElementFromWatchlist(offsets: IndexSet) {
        self.appState.watchlistElements.remove(atOffsets: offsets)
    }
}
