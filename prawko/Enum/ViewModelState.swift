//
//  ViewModelState.swift
//  prawko
//
//  Created by Jakub Klentak on 20/07/2023.
//

import Foundation

public enum ViewModelState
{
    case idle
    case success
    case loading
    case failed(message: String = "Błąd systemu info-share")
}
