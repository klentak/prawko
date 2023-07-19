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
    
    func getProviences(completion: @escaping (Bool) -> Void)
    
    func sortWords(province: Province, completion: @escaping (Bool) -> Void)
}
