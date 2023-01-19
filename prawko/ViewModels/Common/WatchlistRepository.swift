//
//  WatchlistRepository.swift
//  prawko
//
//  Created by Jakub Klentak on 10/01/2023.
//

import Foundation

//set, get & remove User own profile in cache
struct WatchlistRepository {
    static let key = "watchlist"
    
    static func getList() -> [WatchlistElement] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let savedWatchlist = try? JSONDecoder().decode(
                [WatchlistElement].self, from: data
        ) else {
            return []
        }
        
        return savedWatchlist
    }
    
    static func setList(_ value: [WatchlistElement]) {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    static func addElement(_ value: WatchlistElement) {
        do {
            var savedData = getList()
            savedData.append(value)
            let data = try JSONEncoder().encode(savedData)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    static func removeElement(_ offsets: IndexSet) {
        do {
            var savedData = getList()
            savedData.remove(atOffsets: offsets)
            let data = try JSONEncoder().encode(savedData)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
}
