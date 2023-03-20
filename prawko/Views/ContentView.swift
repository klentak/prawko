//
//  ContentView.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI
import KeychainSwift

struct ContentView: View {
    @State private var selection: Tab = .search
    
    enum Tab {
        case search
        case notificationSettings
        case userInformations
    }
    
    var body: some View {
        if (LoginService.shared.isAuthenticated) {
            LoginView()
        } else {
            TabView(selection: $selection) {
                SearchView(notificationView: false)
                    .tabItem {
                        Label("", systemImage: "magnifyingglass")
                    }
                    .tag(Tab.search)
                
                NotificationsSettingsView()
                    .tabItem {
                        Label("", systemImage: "bell")
                    }
                    .tag(Tab.notificationSettings)
                
                UserInformationsView()
                    .tabItem {
                        Label("", systemImage: "person")
                    }
                    .tag(Tab.userInformations)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
