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
//                ForEach(userDefaults.object(forKey: "watchlist") as! [WatchlistElement], id: \.id) {
//                    ExamView(exam: $0)
//                }
                Text("test")
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

struct NotificationsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettingsView()
    }
}
