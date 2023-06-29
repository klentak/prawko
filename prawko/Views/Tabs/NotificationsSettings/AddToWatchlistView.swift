//
//  AddToWatchlistView.swift
//  prawko
//
//  Created by Jakub Klentak on 08/06/2023.
//

import SwiftUI

struct AddToWatchlistView<WordsFormVM, SearchResultVM>: View
where WordsFormVM: WordsFormVMProtocol,
      SearchResultVM: SearchResultVMProtocol {
    @State var formData: WordFormDTO
    
    private var searchResultViewModel: SearchResultVM
    private var wordsFormViewModel: WordsFormVM
    
    init(searchResultViewModel: SearchResultVM, wordsFormViewModel: WordsFormVM) {
        self.searchResultViewModel = searchResultViewModel
        self.wordsFormViewModel = wordsFormViewModel
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
                        viewModel: wordsFormViewModel,
                        formData: $formData
                    )
                    
                    NavigationLink(
                        destination: SearchResultsView(
                            searchResultVM: searchResultViewModel,
                            category: formData.selectedDrivingCategory ?? DrivingLicencesCategoriesConst.values.first!,
                            wordId: String(formData.selectedWord?.id ?? 1),
                            examType: formData.selectedExamType
                        )
                    ) {
                        Label("Dodaj do obserwowanych", systemImage: "plus")
                    }
                    .disabled(
                        formData.selectedProvince == nil
                        || formData.selectedWord == nil
                        || formData.selectedDrivingCategory == nil
                        || formData.selectedExamType == ExamTypeEnum.none
                    )
                }
                Spacer()
            }
                .scrollDisabled(true)
                .navigationBarHidden(true)
        }
    }
}

struct AddToWatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        AddToWatchlistView<WordsFormVMMock, SearchResultVMMock>(
            searchResultViewModel: SearchResultVMMock(scheduledDays: []),
            wordsFormViewModel: WordsFormVMMock(
                proviencesDTO: ProviencesDTO(
                    provinces: [Province](),
                    words: [Word]()
                ),
                sortedWords: []
            )
        )
    }
}
