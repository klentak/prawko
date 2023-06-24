//
//  ContentView.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI
import KeychainSwift

struct ContentView: View {
    @StateObject var appState: AppState

    @State private var selection: Tab

    let loginView: LoginView
    let searchView: SearchView
    let notificationsSettingsView: NotificationsSettingsView
    let userInformationsView: UserInformationsView
    
    init(
        appState: AppState,
        loginView: LoginView,
        searchView: SearchView,
        notificationsSettingsView: NotificationsSettingsView,
        userInformationsView: UserInformationsView
    ) {
        self._appState = StateObject(wrappedValue: appState)
        self._selection = State(initialValue: .search)
        self.loginView = loginView
        self.searchView = searchView
        self.notificationsSettingsView = notificationsSettingsView
        self.userInformationsView = userInformationsView
    }
    
    enum Tab {
        case search
        case notificationSettings
        case userInformations
    }
    
    var body: some View {
        if (!appState.loggedIn) {
            loginView
        } else {
            TabView(selection: $selection) {
                searchView
                    .tabItem {
                        Label("", systemImage: "magnifyingglass")
                    }
                    .tag(Tab.search)
                
                notificationsSettingsView
                    .tabItem {
                        Label("", systemImage: "bell")
                    }
                    .tag(Tab.notificationSettings)
                
                userInformationsView
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
        ContentView(
            appState: AppState(),
            loginView: LoginView(
                viewModel: LoginViewModel(
                    loginService: LoginService(
                        appState: AppState()
                    )
                )
            ),
            searchView: SearchView(),
            notificationsSettingsView: NotificationsSettingsView(
                notificationsSettingsVM: NotificationsSettingsViewModel(),
                watchlist: WatchlistRepository(),
                addToWatchlistView: AddToWatchlistView()
            ),
            userInformationsView: UserInformationsView(
                loginService: LoginService(
                    appState: AppState()
                )
            )
        )
    }
}
