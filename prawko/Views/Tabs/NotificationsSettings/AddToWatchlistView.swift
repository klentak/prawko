//
//  AddToWatchlistView.swift
//  prawko
//
//  Created by Jakub Klentak on 08/06/2023.
//

import SwiftUI

struct AddToWatchlistView<WordsFormVM, NotificationsSettingsAddResultVM>: View
where WordsFormVM: WordsFormVMProtocol,
      NotificationsSettingsAddResultVM: NotificationsSettingsAddResultVMProtocol {
    @ObservedObject private var notificationsSettingsAddResultVM: NotificationsSettingsAddResultVM
    @ObservedObject private var wordsFormVM: WordsFormVM
    
    @State var formData: WordFormDTO
    
    init(notificationsSettingsAddResultVM: NotificationsSettingsAddResultVM, wordsFormVM: WordsFormVM) {
        self.notificationsSettingsAddResultVM = notificationsSettingsAddResultVM
        self.wordsFormVM = wordsFormVM
        self._formData = State(initialValue: WordFormDTO(
            selectedWord: nil,
            selectedProvince: nil,
            selectedDrivingCategory: nil,
            selectedExamType: .none
        ))
    }
    
    var body: some View {
        NavigationView {
            VStack(
                spacing: 10
            ) {
                Section {
                    WordsForm(
                        viewModel: wordsFormVM,
                        formData: $formData,
                        destination: NotificationsSettingsAddResultView(
                            notificationsSettingsAddResultVM: notificationsSettingsAddResultVM,
                            category: formData.selectedDrivingCategory ?? DrivingLicencesCategoriesConst.values.first!,
                            wordId: String(formData.selectedWord?.id ?? 1),
                            type: formData.selectedExamType
                        ),
                        destinationLabelText: "Dodaj do obserwowanych",
                        destinationLabelImage: "plus",
                        examTypeRequired: true
                    )
                }
            }
                .scrollDisabled(true)
                .navigationBarHidden(true)
        }
    }
}

struct AddToWatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        AddToWatchlistView<WordsFormVMMock, NotificationsSettingsAddResultVMMock>(
            notificationsSettingsAddResultVM: NotificationsSettingsAddResultVMMock(
                exam: ExamDTO(
                    additionalInfo: nil,
                    amount: 30,
                    date: "2023-03-18T16:38:16",
                    places: 3
                )
            ),
            wordsFormVM: WordsFormVMMock(
                proviencesDTO: ProviencesDTO(
                    provinces: [Province(id: 1, name: "Test")],
                    words: [Word(id: 1, name: "Test", provinceId: 1)]
                ),
                sortedWords: []
            )
        )
    }
}
