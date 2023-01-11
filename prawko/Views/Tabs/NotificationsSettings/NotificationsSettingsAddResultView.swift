//
//  NotificationsSettingsAddView.swift
//  prawko
//
//  Created by Jakub Klentak on 08/01/2023.
//

import SwiftUI

struct NotificationsSettingsAddResultView: View {
    var notificationsSettingsAddResultVM = NotificationsSettingsAddResultViewModel()
    
    let category : DrivingLicenceCategory
    let wordId : String
    let type : ExamTypeEnum
    
    @State var loading = true
    
    var body: some View {
        VStack {
            if (loading) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(3)
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
                    ExamView(
                        exam: notificationsSettingsAddResultVM.exam!,
                        examType: type,
                        category: category
                    )
                    
                    Spacer()
                    
                    Text("Poinformujemy Cię gdy zwolni się wcześniejszy termin")
                }
            }
            Spacer()
        }
        .onAppear() {
            notificationsSettingsAddResultVM.getScheduledDays(
                category: category,
                wordId: wordId,
                type: type
            ) { completion in
                loading = false
            }
        }
        .navigationBarHidden(true)
    }
}

struct NotificationsSettingsAddResultView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettingsAddResultView(
            category: DrivingLicencesCategoriesConst.values.first!,
            wordId: "1",
            type: ExamTypeEnum.theory
        )
    }
}
