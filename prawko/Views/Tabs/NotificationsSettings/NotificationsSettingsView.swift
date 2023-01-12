//
//  Notification.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI

struct NotificationsSettingsView: View {
    private var userDefaults = UserDefaults.standard
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(WatchlistRepository.get(), id: \.self) { watchlistElement in
                        NotificationRow(watchlistElement: watchlistElement)
                    }
                }
                .navigationTitle(Text("Obserwuj"))
                .navigationBarTitleDisplayMode(
                    NavigationBarItem.TitleDisplayMode.automatic
                )
                .toolbar {
                    ToolbarItemGroup(placement: .confirmationAction) {
                        NavigationLink(destination: SearchView(notificationView: true)) {
                            Label("Dodaj", systemImage: "plus")
                        }
                    }
                }
            }
        }
    }
}

struct NotificationsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettingsView()
    }
}
