//
//  WatchlistRepositoryProtocol.swift
//  prawko
//
//  Created by Jakub Klentak on 26/06/2023.
//

import Foundation

protocol WatchlistRepositoryProtocol: ObservableObject {
    var elements: [WatchlistElement] { get set }
    
    func addElement(_ value: WatchlistElement) throws
    
    func getList() -> [WatchlistElement]
    
    func removeElement(_ offsets: IndexSet)
}
