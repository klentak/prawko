//
//  Search.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI

struct SearchView<WordsFormVM>: View
where WordsFormVM: WordsFormVMProtocol {
    @State var formData: WordFormDTO = WordFormDTO(
        selectedWord: nil,
        selectedProvince: nil,
        selectedDrivingCategory: nil,
        selectedExamType: .none
    )

    @StateObject var wordsFormViewModel: WordsFormVM
    
    var body: some View {
        NavigationView {
            VStack(
                spacing: 10
            ) {
                Section {
                    WordsForm(
                        viewModel: wordsFormViewModel,
                        formData: $formData,
                        destination: SearchResultsView(
                            searchResultVM: CompositionRoot.searchResultViewModel,
                            category: formData.selectedDrivingCategory ?? DrivingLicencesCategoriesConst.values.first!,
                            wordId: String(formData.selectedWord?.id ?? 1),
                            examType: formData.selectedExamType
                        ),
                        destinationLabelText: "Szukaj",
                        destinationLabelImage: "magnifyingglass",
                        examTypeRequired: false
                    )
                }
            }
                .scrollDisabled(true)
                .navigationTitle(Text("Szukaj"))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView<WordsFormVMMock>(
            wordsFormViewModel: WordsFormVMMock(
                proviencesDTO: ProviencesDTO(
                    provinces: [Province(id: 1, name: "Test")],
                    words: [Word(id: 1, name: "Test", provinceId: 1)]
                ),
                sortedWords: [Word(id: 1, name: "Test", provinceId: 1)]
            )
        )
    }
}
