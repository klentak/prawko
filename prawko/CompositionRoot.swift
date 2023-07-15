//
//  CompositionRoot.swift
//  prawko
//
//  Created by Jakub Klentak on 11/06/2023.
//

enum CompositionRoot {
    static var contentView = ContentView<NotificationsSettingsViewModel, WatchlistRepository, NotificationsSettingsAddResultViewModel, WordsFormViewModel, LoginViewModel, LoginService>(
        loginView: loginView,
        searchView: searchView,
        notificationsSettingsView: notificationsSettingsView,
        userInformationsView: userInformationsView
    )
    
    static var watchlistTask = WatchlistTask(
        infoCarRepository: infoCarRepository,
        watchlistRepository: watchlistRepository
    )
    
    static var wordsFormViewModel = WordsFormViewModel()
    
    static var searchResultViewModel = SearchResultViewModel(
        infoCarRepository: infoCarRepository
    )
}

private extension CompositionRoot {
    private static var loginView = LoginView(
        viewModel: LoginViewModel(
            loginService: loginService
        )
    )
    
    private static var searchView = SearchView(wordsFormViewModel: wordsFormViewModel)
    
    private static var addToWatchlistView = AddToWatchlistView(
        notificationsSettingsAddResultVM: notificationsSettingsAddResultViewModel,
        wordsFormVM: wordsFormViewModel
    )
    
    private static var notificationsSettingsView =
        NotificationsSettingsView<NotificationsSettingsViewModel, WatchlistRepository, NotificationsSettingsAddResultViewModel, WordsFormViewModel>(
            notificationsSettingsVM: notificationsSettingsViewModel,
            watchlist: watchlistRepository,
            addToWatchlistView: addToWatchlistView
        )
    
    private static var notificationsSettingsAddResultViewModel = NotificationsSettingsAddResultViewModel(
        apiManager: apiManager,
        watchlistRepository: watchlistRepository
    )

    private static var userInformationsView = UserInformationsView(
        loginService: loginService
    )
    
    private static var notificationsSettingsViewModel = NotificationsSettingsViewModel(
        watchlistRepository: watchlistRepository
    )
    
    private static var infoCarRepository = InfoCarRepository(
        apiManager: apiManager
    )
    
    private static var watchlistRepository = WatchlistRepository()
    
    private static var loginService = LoginService()
    
    private static var interceptor = Interceptor(
        loginService: loginService
    )
    
    private static var apiManager = APIManager(
        interceptor: interceptor
    )
}
