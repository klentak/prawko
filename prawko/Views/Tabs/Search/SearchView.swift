//
//  Search.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI

struct SearchView: View {
    @State var formData: WordFormDTO = WordFormDTO(
        selectedWord: nil,
        selectedProvince: nil,
        selectedDrivingCategory: nil,
        selectedExamType: .none
    )
    
    var body: some View {
        NavigationView {
            VStack(
                spacing: 10
            ) {
                Spacer()
                Section {
                    WordsForm(
                        viewModel: CompositionRoot.wordsFormViewModel,
                        formData: $formData
                    )
                    
                    NavigationLink(
                        destination: SearchResultsView(
                            searchResultVM: CompositionRoot.searchResultViewModel,
                            category: formData.selectedDrivingCategory ?? DrivingLicencesCategoriesConst.values.first!,
                            wordId: String(formData.selectedWord?.id ?? 1),
                            examType: formData.selectedExamType
                        )
                    ) {
                        Label("Szukaj", systemImage: "magnifyingglass")
                    }
                    .disabled(
                        formData.selectedProvince == nil
                        || formData.selectedWord == nil
                        || formData.selectedDrivingCategory == nil
                    )
                }
                Spacer()
            }
                .scrollDisabled(true)
                .navigationTitle(Text("Szukaj"))
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
