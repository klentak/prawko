//
//  Notification.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @StateObject var notificationsSettingsVM: NotificationsSettingsViewModel
    @StateObject var watchlist: WatchlistRepository
    
    var addToWatchlistView: AddToWatchlistView
    
    init(
        notificationsSettingsVM: NotificationsSettingsViewModel,
        watchlist: WatchlistRepository,
        addToWatchlistView: AddToWatchlistView
    ) {
        self._notificationsSettingsVM = StateObject(wrappedValue: notificationsSettingsVM)
        self._watchlist = StateObject(wrappedValue: watchlist)
        self.addToWatchlistView = addToWatchlistView
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
                            if ($watchlist.elements.isEmpty) {
                                Text("Dodaj termin do obserwowanych ↗️")
                            }
                        }
                        
                        ForEach(watchlist.elements, id: \.self) { watchlistElement in
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
        watchlist.removeElement(offsets)
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
        NotificationsSettingsView(
            notificationsSettingsVM: NotificationsSettingsViewModel(),
            watchlist: WatchlistRepository(),
            addToWatchlistView: AddToWatchlistView()
        )
    }
}
