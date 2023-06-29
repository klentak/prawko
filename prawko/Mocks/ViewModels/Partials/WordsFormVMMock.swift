//
//  WordsFormVMMock.swift
//  prawko
//
//  Created by Jakub Klentak on 28/06/2023.
//

import Foundation

class WordsFormVMMock: WordsFormVMProtocol {
    @Published var proviencesDTO: ProviencesDTO
    @Published var sortedWords: [Word]

    init(proviencesDTO: ProviencesDTO, sortedWords: [Word]) {
        self.proviencesDTO = proviencesDTO
        self.sortedWords = sortedWords
    }
    
    func getProviences(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    func sortWords(province: Province, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
