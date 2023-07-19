//
//  Search.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI

struct SearchView<WordsFormVM>: View
where WordsFormVM: WordsFormVMProtocol {
    @ObservedObject var wordsFormVM: WordsFormVM

    @State var formData: WordFormData = WordFormData(
        selectedWord: nil,
        selectedProvince: nil,
        selectedDrivingCategory: nil,
        selectedExamType: .none
    )
    
    var body: some View {
        NavigationView {
            Spacer()
            VStack(
                spacing: 10
            ) {
                Section {
                    WordsForm(
                        viewModel: wordsFormVM,
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
                .navigationBarBackButtonHidden(true)
            Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView<WordsFormVMMock>(
            wordsFormVM: WordsFormVMMock(
                proviencesDTO: Proviences(
                    provinces: [Province(id: 1, name: "Test")],
                    words: [Word(id: 1, name: "Test", provinceId: 1)]
                ),
                sortedWords: [Word(id: 1, name: "Test", provinceId: 1)]
            )
        )
    }
}
