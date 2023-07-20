//
//  WordsFormViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 02/06/2023.
//

import Foundation
import Alamofire

class WordsFormViewModel: WordsFormVMProtocol {
    @Published var proviencesDTO: Proviences
    @Published var sortedWords: [Word]
    
    init() {
        self.proviencesDTO = Proviences(provinces: [Province](), words: [Word]())
        self.sortedWords = [Word]()
    }
    
    func getProviences() {
        AF.request(UrlConst.mainUrl + UrlConst.Dict.provinces)
            .responseDecodable(of: Proviences.self) { response in
            guard let result = response.value else { return }
            self.proviencesDTO = result
        }
    }
    
    func sortWords(province: Province) {
        sortedWords = [Word]()
        for word in proviencesDTO.words {
            if word.provinceId == province.id {
                sortedWords.append(word)
            }
        }
    }
}
