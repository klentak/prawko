//
//  AppStateMock.swift
//  prawko
//
//  Created by Jakub Klentak on 28/06/2023.
//

import Foundation

protocol AppStateProtocol: ObservableObject {
    var loggedIn : Bool
}
