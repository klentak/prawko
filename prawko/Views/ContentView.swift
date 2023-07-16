//
//  ContentView.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI
import KeychainSwift

struct ContentView<NotificationsSettingsVM, WatchlistRepository, NotificationsSettingsAddResultVM, WordsFormVM, LoginViewModel, LoginService>: View
where NotificationsSettingsVM: NotificationsSettingsVMProtocol,
      WatchlistRepository: WatchlistRepositoryProtocol,
      NotificationsSettingsAddResultVM: NotificationsSettingsAddResultVMProtocol,
      LoginViewModel: LoginVMProtocol,
      WordsFormVM: WordsFormVMProtocol,
      LoginService: LoginServiceProtocol {
    @StateObject var appState: AppState

    @State private var selection: Tab

    let loginView: LoginView<LoginViewModel>
    let searchView: SearchView<WordsFormVM>
    let notificationsSettingsView: NotificationsSettingsView<NotificationsSettingsVM, WatchlistRepository, NotificationsSettingsAddResultVM, WordsFormVM>
    let userInformationsView: UserInformationsView<LoginService>
    
    init(
        appState: AppState,
        loginView: LoginView<LoginViewModel>,
        searchView: SearchView<WordsFormVM>,
        notificationsSettingsView: NotificationsSettingsView<NotificationsSettingsVM, WatchlistRepository, NotificationsSettingsAddResultVM, WordsFormVM>,
        userInformationsView: UserInformationsView<LoginService>
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
        let appState = AppState(loggedIn: true)
        let loginService = LoginServiceMockLoggedIn(
            appState: appState
        )
        let wordsFormVM = WordsFormVMMock(
            proviencesDTO: ProviencesDTO(
                provinces: [Province(id: 1, name: "Test")],
                words: [Word(id: 1, name: "Test", provinceId: 1)]
            ),
            sortedWords: [Word(id: 1, name: "Test", provinceId: 1)]
        )

        ContentView<NotificationsSettingsVMMock, WatchlistRepositoryMock, NotificationsSettingsAddResultVMMock, WordsFormVMMock, LoginVMMock, LoginServiceMockLoggedIn>(
            appState: appState,
            loginView: LoginView(
                viewModel: LoginVMMock(
                    loginService: loginService
                )
            ),
            searchView: SearchView(
                wordsFormViewModel: wordsFormVM
            ),
            notificationsSettingsView: NotificationsSettingsView(
                notificationsSettingsVM: NotificationsSettingsVMMock(
                    words: [],
                    notificationsEnabled: true,
                    appState: appState
                ),
                watchlist: WatchlistRepositoryMock(),
                addToWatchlistView: AddToWatchlistView(
                    notificationsSettingsAddResultVM: NotificationsSettingsAddResultVMMock(exam: nil),
                    wordsFormVM: wordsFormVM
                ),
                appState: appState
            ),
            userInformationsView: UserInformationsView(
                loginService: loginService
            )
        )
    }
}
