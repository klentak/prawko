//
//  CompositionRoot.swift
//  prawko
//
//  Created by Jakub Klentak on 11/06/2023.
//

enum CompositionRoot {
    static var contentView = ContentView<NotificationsSettingsViewModel, WatchlistRepository, NotificationsSettingsAddResultViewModel<WatchlistRepository>, WordsFormViewModel, LoginViewModel, LoginService>(
        appState: appState,
        loginView: loginView,
        searchView: searchView,
        notificationsSettingsView: notificationsSettingsView,
        userInformationsView: userInformationsView
    )
    
    static var watchlistTask = WatchlistTask(
        infoCarRepository: infoCarRepository,
        watchlistRepository: watchlistRepository
    )
    
    static var wordsFormViewModel = WordsFormViewModel(
        infoCarRepository: infoCarRepository
    )
    
    static var searchResultViewModel = SearchResultViewModel(
        infoCarRepository: infoCarRepository
    )
    
    static var appState =
    AppState(loggedIn: false)
}

private extension CompositionRoot {
    private static var loginView = LoginView(
        viewModel: LoginViewModel(
            loginService: loginService
        )
    )
    
    private static var searchView = SearchView(wordsFormVM: wordsFormViewModel)
    
    private static var addToWatchlistView = AddToWatchlistView(
        notificationsSettingsAddResultVM: notificationsSettingsAddResultViewModel,
        wordsFormVM: wordsFormViewModel
    )
    
    private static var notificationsSettingsView =
    NotificationsSettingsView<NotificationsSettingsViewModel, WatchlistRepository, NotificationsSettingsAddResultViewModel<WatchlistRepository>, WordsFormViewModel>(
            notificationsSettingsVM: notificationsSettingsViewModel,
            watchlist: watchlistRepository,
            addToWatchlistView: addToWatchlistView,
            appState: appState
        )
    
    private static var notificationsSettingsAddResultViewModel = NotificationsSettingsAddResultViewModel(
        apiManager: apiManager,
        watchlistRepository: watchlistRepository,
        appState: appState
    )

    private static var userInformationsView = UserInformationsView(
        loginService: loginService
    )
    
    private static var notificationsSettingsViewModel = NotificationsSettingsViewModel(
        watchlistRepository: watchlistRepository,
        appState: appState,
        infoCarRepository: infoCarRepository
    )
    
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
