//
//  Notification.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @StateObject var notificationsSettingsVM = NotificationsSettingsViewModel()
    @State var watchlist = WatchlistRepository.getList()
    @State var downloadDataAlert = false
    @State var loading = true
    
    var body: some View {
        NavigationView {
            if (loading) {
                CommonProgressView()
            } else {
                VStack {
                    List {
                        if (watchlist.isEmpty) {
                            Text("Dodaj termin do obserwowanych ↗️")
                        }
                        
                        ForEach(watchlist, id: \.self) { watchlistElement in
                            NotificationRowView(
                                watchlistElement: watchlistElement,
                                wordName: getWordName(wordId: watchlistElement.wordId)
                            )
                        }
                        .onDelete(perform: delete)
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
                            .onDisappear() {
                                watchlist = WatchlistRepository.getList()
                            }
                        }
                    }
                }
            }
        }
            .navigationViewStyle(.stack)
            .onAppear() {
                notificationsSettingsVM.getProviences() { completion in
                    switch completion {
                    case true:
                        loading = false
                    case false:
                        downloadDataAlert = true
                    }
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
        WatchlistRepository.removeElement(offsets)
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
        NotificationsSettingsView()

    }
}