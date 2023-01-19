//
//  NotificationsSettingsViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 15/01/2023.
//

import Foundation
import Alamofire

class NotificationsSettingsViewModel : ObservableObject {
    @Published var words: [Word] = [Word]()
    
    func getProviences(completion: @escaping (Bool) -> Void) {
        AF.request(UrlConst.mainUrl + UrlConst.Dict.provinces).responseDecodable(of: ProviencesDTO.self) { response in
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
}
