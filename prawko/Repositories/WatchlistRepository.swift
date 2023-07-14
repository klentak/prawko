//
//  WatchlistRepository.swift
//  prawko
//
//  Created by Jakub Klentak on 10/01/2023.
//

import Foundation

class WatchlistRepository : WatchlistRepositoryProtocol {
    var decoder = JSONDecoder()
    var encoder = JSONEncoder()
    let key = "watchlist"
    
    init() {
        self.updateList()
    }
    
    public func getList() -> [WatchlistElement] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let savedWatchlist = try? decoder.decode(
                [WatchlistElement].self, from: data
        ) else {
            return []
        }
        
        return savedWatchlist
    }
    
    public func addElement(_ value: WatchlistElement) throws {
        if isAlreadyInWishlist(value) {
            throw WatchlistRespositoryError.alreadyAdded(
                "Egzamin jest już na liście obserwowanych"
            )
        }
        do {
            var savedData = getList()
            savedData.append(value)
            let data = try encoder.encode(savedData)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
        self.updateList()
    }
    
    public func removeElement(_ offsets: IndexSet) {
        do {
            var savedData = getList()
            savedData.remove(atOffsets: offsets)
            let data = try encoder.encode(savedData)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
        self.updateList()
    }
    
    private func updateList() -> Void {
        guard let data = UserDefaults.standard.data(forKey: key),
              let savedWatchlist = try? decoder.decode(
                [WatchlistElement].self, from: data
        ) else {
            return
        }
    }
    
    private func setList(_ value: [WatchlistElement]) {
        do {
            let data = try encoder.encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    private func isAlreadyInWishlist(_ value: WatchlistElement) -> Bool {
        for wishlistElement in getList() {
            if (
                value.type == wishlistElement.type
                && value.category == wishlistElement.category
                && value.wordId == wishlistElement.wordId
            ) {
                return true
            }
        }
        return false
    }
}
