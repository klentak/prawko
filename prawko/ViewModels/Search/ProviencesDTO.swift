//
//  ProviencesDecodable.swift
//  prawko
//
//  Created by Jakub Klentak on 03/12/2022.
//

import Foundation

public struct ProviencesDTO: Decodable, Hashable {
    let provinces : [Province]
    let words : [Word]
}

public struct Province : Decodable, Hashable, Identifiable {
    public let id : Int
    public let name : String
}

public struct Word : Decodable, Hashable, Identifiable {
    public let id : Int
    public let name : String
    public let provinceId : Int
}
