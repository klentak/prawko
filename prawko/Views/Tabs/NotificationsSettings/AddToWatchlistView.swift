//
//  AddToWatchlistView.swift
//  prawko
//
//  Created by Jakub Klentak on 08/06/2023.
//

import SwiftUI

struct AddToWatchlistView: View {
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
                    WordsForm(formData: $formData)
                    
                    NavigationLink(
                        destination: SearchResultsView(
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
                .navigationTitle(Text("Szukaj"))
        }
    }
}

struct AddToWatchlistView_Previews: PreviewProvider {
    static var previews: some View {
        AddToWatchlistView()
    }
}
