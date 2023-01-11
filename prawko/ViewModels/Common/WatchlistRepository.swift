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
    
    static func get() -> [WatchlistElement] {
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
            var savedData = get()
            savedData.append(value)
            let data = try JSONEncoder().encode(savedData)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
}
