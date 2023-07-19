//
//  Notification.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI

struct NotificationsSettingsView<NotificationSettingsVM, WatchlistRepository, NotificationsSettingsAddResultVM, WordsFormVM>: View
where NotificationSettingsVM: NotificationsSettingsVMProtocol,
      WatchlistRepository: WatchlistRepositoryProtocol,
      NotificationsSettingsAddResultVM: NotificationsSettingsAddResultVMProtocol,
      WordsFormVM: WordsFormVMProtocol {
    @ObservedObject var notificationsSettingsVM: NotificationSettingsVM
    
    @StateObject var appState: AppState
    
    var addToWatchlistView: AddToWatchlistView<WordsFormVM, NotificationsSettingsAddResultVM>
    
    init(
        notificationsSettingsVM: NotificationSettingsVM,
        watchlist: WatchlistRepository,
        addToWatchlistView: AddToWatchlistView<WordsFormVM, NotificationsSettingsAddResultVM>,
        appState: AppState
    ) {
        self._notificationsSettingsVM = ObservedObject(wrappedValue: notificationsSettingsVM)
        self.addToWatchlistView = addToWatchlistView
        self._appState = StateObject(wrappedValue: appState)
    }
    
    @State var notificationAlertsEnabled = false
    @State var downloadDataAlert = false
    @State var loading = true
    
    var body: some View {
        NavigationView {
            if (loading) {
                CommonProgressView()
            } else {
                VStack {
                    List {
                        if (!notificationAlertsEnabled) {
                            Text("Aby dodać termin do obserwowanych musisz w ustawieniach nadać aplikacji dostęp do powiadomień!")
                                .foregroundColor(.red)
                        } else {
                            if (appState.watchlistElements.isEmpty) {
                                Text("Dodaj termin do obserwowanych ↗️")
                            }
                        }
                        
                        ForEach(appState.watchlistElements, id: \.self) { watchlistElement in
                            NotificationRowView(
                                watchlistElement: watchlistElement,
                                wordName: getWordName(wordId: watchlistElement.wordId)
                            )
                        }
                            .onDelete(perform: delete)
                    }
                    .navigationTitle(Text("Obserwowane"))
                    .navigationBarTitleDisplayMode(
                        NavigationBarItem.TitleDisplayMode.automatic
                    )
                    .toolbar {
                        ToolbarItemGroup(placement: .confirmationAction) {
                            NavigationLink(destination: addToWatchlistView) {
                                Label("Dodaj", systemImage: "plus")
                            }
                            .disabled(!notificationAlertsEnabled)
                        }
                    }
                }
            }
        }
            .navigationViewStyle(.stack)
            .onAppear() {
                notificationsSettingsVM.setAllowNotifications()
                
                notificationsSettingsVM.getProviences() { completion in
                    switch completion {
                    case true:
                        loading = false
                    case false:
                        downloadDataAlert = true
                    }
                }
                
                notificationsSettingsVM.isNotificationsEnabled() { result in
                    notificationAlertsEnabled = result
                }
            }
            .alert(isPresented: $downloadDataAlert) {
                Alert(
                    title: Text("Błąd systemu info-share"),
                     message: Text("Spróbuj ponownie później"),
                     dismissButton: .default(Text("OK"))
                )
            }
    }
    
    func delete(at offsets: IndexSet) {
        notificationsSettingsVM.removeElementFromWatchlist(offsets: offsets)
    }
    
    func getWordName(wordId: String) -> String {
        guard let wordName = notificationsSettingsVM.getWordById(wordId: wordId)?.name else {
            downloadDataAlert = true
            return ""
        }
        
        return wordName
    }
}

struct NotificationsSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let watchListElement = WatchlistElement(
            category: DrivingLicencesCategoriesConst.values.first!,
            wordId: "1",
            type: ExamTypeEnum.practice,
            latestExam: Exam(
                additionalInfo: nil,
                amount: 30,
                date: "2023-03-18T16:38:16",
                places: 3
            )
        )
        
        let addToWatchlistView = AddToWatchlistView(
            notificationsSettingsAddResultVM: NotificationsSettingsAddResultVMMock(exam: nil),
            wordsFormVM: WordsFormVMMock(
                proviencesDTO: Proviences(
                    provinces: [Province(id: 1, name: "Test")],
                    words: [Word(id: 2, name: "Test", provinceId: 1)]
                ),
                sortedWords: []
            )
        )
        
        var emptyAppState = AppState(loggedIn: true)
        var appStateWithWatchlistElements = AppState(loggedIn: true)
        
        Group {
            NotificationsSettingsView(
                notificationsSettingsVM: NotificationsSettingsVMMock(
                    words: [
                        Word(
                            id: 1,
                            name: "Test",
                            provinceId: 1
                        )
                    ],
                    notificationsEnabled: false,
                    appState: emptyAppState
                ),
                watchlist: WatchlistRepositoryMock(),
                addToWatchlistView: addToWatchlistView,
                appState: emptyAppState
            )

            NotificationsSettingsView(
                notificationsSettingsVM: NotificationsSettingsVMMock(
                    words: [
                        Word(
                            id: 1,
                            name: "Test",
                            provinceId: 1
                        )
                    ],
                    notificationsEnabled: true,
                    appState: emptyAppState
                ),
                watchlist: WatchlistRepositoryMock(),
                addToWatchlistView: addToWatchlistView,
                appState: emptyAppState
            )

            NotificationsSettingsView(
                notificationsSettingsVM: NotificationsSettingsVMMock(
                    words: [
                        Word(
                            id: 1,
                            name: "Test",
                            provinceId: 1
                        )
                    ],
                    notificationsEnabled: true,
                    appState: {
                        appStateWithWatchlistElements.watchlistElements = [
                            watchListElement,
                            watchListElement
                        ]
                        return appStateWithWatchlistElements
                    }()
                ),
                watchlist: WatchlistRepositoryMock(),
                addToWatchlistView: addToWatchlistView,
                appState: appStateWithWatchlistElements
            )
        }
    }
}
