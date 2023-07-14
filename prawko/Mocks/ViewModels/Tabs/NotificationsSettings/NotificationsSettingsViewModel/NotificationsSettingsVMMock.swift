//
//  NotificationsSettingsViewModelMock.swift
//  prawko
//
//  Created by Jakub Klentak on 25/06/2023.
//

import Foundation

class NotificationsSettingsVMMock: ObservableObject, NotificationsSettingsVMProtocol {
    var watchlistElements: [WatchlistElement]
    
    @Published var words: [Word]
    
    var notificationsEnabled = false;
    
    init(words: [Word], watchlistElements: [WatchlistElement]) {
        self.words = words
        self.watchlistElements = watchlistElements
    }
    
    func getProviences(completion: @escaping (Bool) -> Void) {
        completion(true);
    }
    
    func getWordById(wordId: String) -> Word? {
        return Word(
            id: 1,
            name: "Test",
            provinceId: 1
        );
    }
    
    func setAllowNotifications() {
        self.notificationsEnabled = true;
    }
    
    func isNotificationsEnabled(completion: @escaping (Bool) -> Void) {
        completion(self.notificationsEnabled);
    }
    
    func removeElementFromWatchlist(offsets: IndexSet) {
        watchlistElements.remove(atOffsets: offsets)
    }
}
