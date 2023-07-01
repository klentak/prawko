//
//  NotificationsSettingsViewModelMock.swift
//  prawko
//
//  Created by Jakub Klentak on 25/06/2023.
//

import Foundation

class NotificationsSettingsVMMock: ObservableObject, NotificationsSettingsVMProtocol {
    @Published var words: [Word]
    
    var notificationsEnabled = false;
    
    init(words: [Word]) {
        self.words = words
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
}
