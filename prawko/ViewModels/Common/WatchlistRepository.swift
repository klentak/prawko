//
//  WatchlistRepository.swift
//  prawko
//
//  Created by Jakub Klentak on 10/01/2023.
//

import Foundation

class WatchlistRepository : ObservableObject {
    @Published var elements: [WatchlistElement] = [WatchlistElement]()
    
    var decoder = JSONDecoder()
    var encoder = JSONEncoder()
    let key = "watchlist"
    
    private init() {
        self.updateList()
    }
    
    static var shared: WatchlistRepository = {
       let instance = WatchlistRepository()

       return instance
    }()
    
    func updateList() -> Void {
        guard let data = UserDefaults.standard.data(forKey: key),
              let savedWatchlist = try? decoder.decode(
                [WatchlistElement].self, from: data
        ) else {
            return
        }

        elements = savedWatchlist
    }
    
    func getList() -> [WatchlistElement] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let savedWatchlist = try? decoder.decode(
                [WatchlistElement].self, from: data
        ) else {
            return []
        }
        
        return savedWatchlist
    }
    
    func setList(_ value: [WatchlistElement]) {
        do {
            let data = try encoder.encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func addElement(_ value: WatchlistElement) {
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
    
    func removeElement(_ offsets: IndexSet) {
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
}
