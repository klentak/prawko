//
//  ApiConectionError.swift
//  prawko
//
//  Created by Jakub Klentak on 30/03/2023.
//

import Foundation

enum ApiConectionError: Error {
    case parseData(String)
    case login(String)
}
