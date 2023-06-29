//
//  NotificationsSettingsAddView.swift
//  prawko
//
//  Created by Jakub Klentak on 08/01/2023.
//

import SwiftUI

struct NotificationsSettingsAddResultView<ViewModel>: View
where ViewModel: NotificationsSettingsAddResultVMProtocol {
    @ObservedObject var notificationsSettingsAddResultVM: ViewModel

    let category : DrivingLicenceCategory
    let wordId : String
    let type : ExamTypeEnum
    
    init(
        notificationsSettingsAddResultVM: ViewModel,
        category: DrivingLicenceCategory,
        wordId: String,
        type: ExamTypeEnum
    ) {
        self.notificationsSettingsAddResultVM = notificationsSettingsAddResultVM
        self.category = category
        self.wordId = wordId
        self.type = type
    }

    @State var errorTitle = "Błąd systemu info-share"
    @State var errorMessage = "Spróbuj ponownie później"
    
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
                    switch completion {
                    case .success:
                        loading = false
                    case .failure(let error):
                        switch error {
                        case WatchlistRespositoryError.alreadyAdded(let error):
                            self.errorTitle = "Błąd"
                            self.errorMessage = error.description
                        default:
                            print("default")
                        }
                        
                        downloadDataAlert = true
                    }
                }
                
                BackgroundAppRefresherService.shared.scheduleNotifications()
            }
            .navigationBarHidden(true)
            .alert(isPresented: $downloadDataAlert) {
                Alert(
                    title: Text(self.errorTitle),
                    message: Text(self.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

struct NotificatiopnsSettingsAddResultView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NotificationsSettingsAddResultView(
                notificationsSettingsAddResultVM: NotificationsSettingsAddResultVMMock(
                        exam: ExamDTO(
                            additionalInfo: nil,
                            amount: 23,
                            date: "2022-10-26T18:28:10",
                            places: 2
                        )
                    ),
                category: DrivingLicencesCategoriesConst.values.first!,
                wordId: "1",
                type: ExamTypeEnum.theory
            )
            NotificationsSettingsAddResultView(
                notificationsSettingsAddResultVM: NotificationsSettingsAddResultVMMock(exam: nil),
                category: DrivingLicencesCategoriesConst.values.first!,
                wordId: "1",
                type: ExamTypeEnum.theory
            )
            NotificationsSettingsAddResultView(
                notificationsSettingsAddResultVM: NotificationsSettingsAddResultVMErrorMock(),
                category: DrivingLicencesCategoriesConst.values.first!,
                wordId: "1",
                type: ExamTypeEnum.theory
            )
        }
    }
}
