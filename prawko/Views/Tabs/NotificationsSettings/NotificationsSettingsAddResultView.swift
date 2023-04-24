//
//  NotificationsSettingsAddView.swift
//  prawko
//
//  Created by Jakub Klentak on 08/01/2023.
//

import SwiftUI

struct NotificationsSettingsAddResultView: View {
    @ObservedObject var notificationsSettingsAddResultVM = NotificationsSettingsAddResultViewModel()
    
    let category : DrivingLicenceCategory
    let wordId : String
    let type : ExamTypeEnum
    
    @State var loading = true
    @State var downloadDataAlert = false
    
    var body: some View {
        VStack {
            if (loading) {
                CommonProgressView()
            } else {
                if (notificationsSettingsAddResultVM.exam == nil) {
                    VStack {
                        Text("Aktualnie brak terminów.")
                        Spacer()
                        Text("Poinformujemy Cię gdy jakiś się pojawi.")
                        Spacer()
                    }
                        .frame(height: 100)
                } else {
                    Text("Najbliższy termin")
                        .font(.largeTitle)
                    
                    Spacer()
                    
                    ExamView(
                        exam: notificationsSettingsAddResultVM.exam!,
                        examType: type,
                        category: category
                    )
                    
                    Spacer()
                    
                    Text("Poinformujemy Cię gdy zwolni się wcześniejszy termin")
                        .bold()
                    
                    Spacer()
                }
            }
        }
            .onAppear() {
                notificationsSettingsAddResultVM.getScheduledDays(
                    category: category,
                    wordId: wordId,
                    type: type
                ) { completion in
                    if (completion) {
                        loading = false
                    } else {
                        downloadDataAlert = true
                    }
                }
                
                BackgroundAppRefresherService.shared.scheduleNotifications()
            }
            .navigationBarHidden(true)
            .alert(isPresented: $downloadDataAlert) {
                Alert(
                    title: Text("Błąd systemu info-share"),
                     message: Text("Spróbuj ponownie później"),
                     dismissButton: .default(Text("OK"))
                )
            }
    }
}

struct NotificatiopnsSettingsAddResultView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettingsAddResultView(
            category: DrivingLicencesCategoriesConst.values.first!,
            wordId: "1",
            type: ExamTypeEnum.theory
        )
    }
}
