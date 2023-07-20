//
//  WordsFormVMMock.swift
//  prawko
//
//  Created by Jakub Klentak on 28/06/2023.
//

import Foundation

class WordsFormVMMock: WordsFormVMProtocol {
    @Published var proviencesDTO: Proviences
    @Published var sortedWords: [Word]

    init(proviencesDTO: Proviences, sortedWords: [Word]) {
        self.proviencesDTO = proviencesDTO
        self.sortedWords = sortedWords
    }
    
    func getProviences() {
    }
    
    func sortWords(province: Province) {
    }
}
