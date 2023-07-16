//
//  NotificationsSettingsViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 15/01/2023.
//

import Foundation
import Alamofire
import SwiftUI

class NotificationsSettingsViewModel: NotificationsSettingsVMProtocol {
    @StateObject var appState: AppState

    var watchlistRepository: WatchlistRepository
    
    @Published var words: [Word]
    
    init(watchlistRepository: WatchlistRepository, appState: AppState) {
        self.watchlistRepository = watchlistRepository
        appState.watchlistElements = watchlistRepository.getList()
        self._appState = StateObject(wrappedValue: appState)
        self.words = [Word]()
    }
    
    func getProviences(completion: @escaping (Bool) -> Void) {
        AF.request(UrlConst.mainUrl + UrlConst.Dict.provinces)
            .responseDecodable(of: ProviencesDTO.self) { response in
            guard let result = response.value else {
                completion(false)
                return
            }
            self.words = result.words
            completion(true)
        }
    }
    
    func getWordById(wordId: String) -> Word? {
        for word in words {
            if (word.id == Int(wordId)) {
                return word
            }
        }
        
        return nil
    }
    
    func setAllowNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func isNotificationsEnabled(completion: @escaping (Bool) -> Void) -> Void {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized
                    || settings.authorizationStatus == .provisional else {
                completion(false)
                return
            }

            completion(true)
        }
    }
    
    func removeElementFromWatchlist(offsets: IndexSet) {
        self.watchlistRepository.removeElement(offsets)
        self.appState.watchlistElements = self.watchlistRepository.getList()
    }
}
