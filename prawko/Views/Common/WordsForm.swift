//
//  WordsForm.swift
//  prawko
//
//  Created by Jakub Klentak on 31/05/2023.
//

import SwiftUI

struct WordsForm: View {
    @StateObject private var viewModel: WordsFormViewModel
    
    @Binding var formData: WordFormDTO
    
    init(viewModel: WordsFormViewModel, formData: Binding<WordFormDTO>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._formData = formData
    }
    
    var body: some View {
        VStack(
            spacing: 10
        ) {
            if (!viewModel.proviencesDTO.words.isEmpty) {
                Form {
                    Section(header: Text("Województwo")) {
                        Picker("Województwo", selection: $formData.selectedProvince) {
                            if (formData.selectedProvince == nil) {
                                Text("").tag(Optional<String>(nil))
                            }
                            ForEach(viewModel.proviencesDTO.provinces, id: \.self) { province in
                                Text(province.name).tag(province as Province?)
                            }
                        }
                        .onChange(of: formData.selectedProvince) { _ in
                            if (formData.selectedProvince != nil) {
                                viewModel.sortWords(province: formData.selectedProvince!) { _ in
                                }
                                formData.selectedWord = nil
                            }
                        }
                    }
                    
                    Section(header: Text("Ośrodek egzaminacyjny")) {
                        Picker("Word", selection: $formData.selectedWord) {
                            if (formData.selectedWord == nil) {
                                Text("").tag(Optional<String>(nil))
                            }
                            ForEach(viewModel.sortedWords) {
                                Text($0.name).tag($0 as Word?)
                            }
                        }
                    }
                    
                    Section(header: Text("Kategoria prawa jazdy")) {
                        Picker("Kategoria", selection: $formData.selectedDrivingCategory) {
                            if (formData.selectedDrivingCategory == nil) {
                                Text("").tag(Optional<String>(nil))
                            }
                            ForEach(DrivingLicencesCategoriesConst.values, id: \.id) {
                                Text($0.name).tag($0 as DrivingLicenceCategory?)
                            }
                        }
                    }
                    
                    Section(header: Text("Rodzaj egzaminu")) {
                        Picker("Rodzaj", selection: $formData.selectedExamType) {
                            ForEach(ExamTypeEnum.allCases) { value in
                                Text(value.rawValue)
                                    .tag(value)
                            }
                        }
                    }
                    
                }
            } else {
                CommonProgressView()
                    .onAppear() {
                        viewModel.getProviences() { completion in
                        }
                    }
            }
        }
    }
}

struct WordsForm_Previews: PreviewProvider {
    static var previews: some View {
        WordsForm(
            viewModel: WordsFormViewModel(),
            formData: .constant(
                WordFormDTO(
                    selectedWord: nil,
                    selectedProvince: nil,
                    selectedDrivingCategory: nil,
                    selectedExamType: .none
                )
            )
        )
    }
}
