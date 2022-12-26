//
//  SearchViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 19/12/2022.
//

import SwiftUI
import Alamofire

class SearchViewModel : ObservableObject {
    @Published var proviencesDTO: ProviencesDTO = ProviencesDTO(provinces: [Province](), words: [Word]())
    @Published var sortedWords: [Word] = [Word]()
    
    func getProviences(completion: @escaping (Bool) -> Void) {
        AF.request(UrlConst.mainUrl + UrlConst.Dict.provinces).responseDecodable(of: ProviencesDTO.self) { response in
            guard let result = response.value else { return }
            self.proviencesDTO = result
            completion(true)
        }
    }
    
    func sortWords(province: Province, completion: @escaping (Bool) -> Void) {
        sortedWords = [Word]()
        for word in proviencesDTO.words {
            if word.provinceId == province.id {
                sortedWords.append(word)
                completion(true)
            }
        }
    }
}
    
