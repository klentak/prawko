//
//  WordsFormVMProtocol.swift
//  prawko
//
//  Created by Jakub Klentak on 28/06/2023.
//

import Foundation

protocol WordsFormVMProtocol: ObservableObject {
    var proviencesDTO: Proviences { get }
    var sortedWords: [Word] { get }
    
    func getProviences()
    func sortWords(province: Province)
}
