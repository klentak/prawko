//
//  CompositionRoot.swift
//  prawko
//
//  Created by Jakub Klentak on 11/06/2023.
//

enum CompositionRoot {
    static var contentView = ContentView(
        appState: appState,
        loginView: loginView,
        searchView: searchView,
        notificationsSettingsView: notificationsSettingsView,
        userInformationsView: userInformationsView
    )
    
    static var watchlistTask = WatchlistTask(
        infoCarRepository: infoCarRepository
    )
    
    static var wordsFormViewModel = WordsFormViewModel()
    
    static var searchResultViewModel = SearchResultViewModel(
        infoCarRepository: infoCarRepository
    )
    
    static var appState = AppState()
}

private extension CompositionRoot {
    private static var loginView = LoginView(
        viewModel: LoginViewModel(
            loginService: loginService
        )
    )
    
    private static var searchView = SearchView()
    
    private static var addToWatchlistView = AddToWatchlistView()
    
    private static var notificationsSettingsView = NotificationsSettingsView(
        notificationsSettingsVM: notificationsSettingsViewModel,
        watchlist: watchlistRepository,
        addToWatchlistView: addToWatchlistView
    )

    private static var userInformationsView = UserInformationsView(
        loginService: loginService
    )
    
    private static var notificationsSettingsViewModel = NotificationsSettingsViewModel()
    
    private static var infoCarRepository = InfoCarRepository(
        apiManager: apiManager
    )
    
    private static var watchlistRepository = WatchlistRepository()
    
    private static var loginService = LoginService(
        appState: appState
    )
    
    private static var interceptor = Interceptor(
        loginService: loginService
    )
    
    private static var apiManager = APIManager(
        interceptor: interceptor
    )
}
