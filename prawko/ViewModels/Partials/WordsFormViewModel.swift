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
    
    var infoCarRepository: InfoCarRepository
    
    init(infoCarRepository: InfoCarRepository) {
        self.proviencesDTO = Proviences(provinces: [Province](), words: [Word]())
        self.sortedWords = [Word]()
        self.infoCarRepository = infoCarRepository
    }
    
    func getProviences() {
        infoCarRepository.getProviences() { result in
            switch result {
            case .failure(_):
                return
            case .success(let provinces):
                self.proviencesDTO = provinces
            }
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
