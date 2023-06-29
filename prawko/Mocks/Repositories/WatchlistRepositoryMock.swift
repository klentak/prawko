//
//  WatchlistRepositoryMock.swift
//  prawko
//
//  Created by Jakub Klentak on 26/06/2023.
//

import Foundation

class WatchlistRepositoryMock : ObservableObject, WatchlistRepositoryProtocol {
    var elements: [WatchlistElement]
    
    init(elements: [WatchlistElement]) {
        self.elements = elements
    }
    
    func addElement(_ value: WatchlistElement) throws {
        self.elements.append(value)
    }
    
    func getList() -> [WatchlistElement] {
        return elements
    }
    
    func removeElement(_ offsets: IndexSet) {
        elements.remove(atOffsets: offsets)
    }
}
