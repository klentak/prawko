//
//  LoginError.swift
//  prawko
//
//  Created by Jakub Klentak on 17/04/2023.
//

import Foundation

enum LoginError: Error {
    case csrf
    case login
    case bearer
}
