//
//  WordsForm.swift
//  prawko
//
//  Created by Jakub Klentak on 31/05/2023.
//

import SwiftUI

struct WordsForm<WordsFormVM, Destination>: View
where WordsFormVM: WordsFormVMProtocol,
      Destination: View {
    @StateObject private var viewModel: WordsFormVM
        @Binding var formData: WordFormDTO
    
    var destination: Destination
    var destinationLabelText: String
    var destinationLabelImage: String
    var examTypeRequired: Bool
    
    init(
        viewModel: WordsFormVM,
        formData: Binding<WordFormDTO>,
        destination: Destination,
        destinationLabelText: String,
        destinationLabelImage: String,
        examTypeRequired: Bool
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._formData = formData
        self.destination = destination
        self.destinationLabelText = destinationLabelText
        self.destinationLabelImage = destinationLabelImage
        self.examTypeRequired = examTypeRequired
    }
    
    var body: some View {
        VStack(
            spacing: 10
        ) {
            if (!viewModel.proviencesDTO.words.isEmpty) {
                Form {
                    Section(header: Text("Województwo") + requiredIdentificator()) {
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
                    
                    Section(header: Text("Ośrodek egzaminacyjny") + requiredIdentificator()) {
                        Picker("Word", selection: $formData.selectedWord) {
                            if (!viewModel.sortedWords.isEmpty) {
                                Text("").tag(Optional<String>(nil))
                            }
                            ForEach(viewModel.sortedWords) {
                                Text($0.name).tag($0 as Word?)
                            }
                        }
                    }
                    
                    Section(header: Text("Kategoria prawa jazdy") + requiredIdentificator()) {
                        Picker("Kategoria", selection: $formData.selectedDrivingCategory) {
                            if (formData.selectedDrivingCategory == nil) {
                                Text("").tag(Optional<String>(nil))
                            }
                            ForEach(DrivingLicencesCategoriesConst.values, id: \.id) {
                                Text($0.name).tag($0 as DrivingLicenceCategory?)
                            }
                        }
                    }
                    
                    Section(
                        header: examTypeRequired
                            ? Text("Rodzaj egzaminu") + requiredIdentificator()
                            : Text("Rodzaj egzaminu")
                    ) {
                        Picker("Rodzaj", selection: $formData.selectedExamType) {
                            ForEach(ExamTypeEnum.allCases) { value in
                                Text(value.rawValue)
                                    .tag(value)
                            }
                        }
                    }
                    
                    NavigationLink(
                        destination: self.destination
                    ) {
                        Label(
                            self.destinationLabelText,
                            systemImage: self.destinationLabelImage
                        )
                    }
                        .disabled(
                            formData.selectedProvince == nil
                            || formData.selectedWord == nil
                            || formData.selectedDrivingCategory == nil
                            || (formData.selectedExamType == .none && self.examTypeRequired)
                        )
                    
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
    
    func requiredIdentificator() -> Text {
        Text(" *")
            .foregroundColor(.red)
            .bold()
    }
}

struct WordsForm_Previews: PreviewProvider {
    static var previews: some View {
        WordsForm<WordsFormVMMock, SearchResultsView<SearchResultVMMock>>(
            viewModel: WordsFormVMMock(
                proviencesDTO: ProviencesDTO(
                    provinces: [Province(id: 1, name: "Test")],
                    words: [Word(id: 2, name: "Test", provinceId: 1)]
                ),
                sortedWords: []
            ),
            formData: .constant(
                WordFormDTO(
                    selectedWord: nil,
                    selectedProvince: nil,
                    selectedDrivingCategory: nil,
                    selectedExamType: .none
                )
            ),
            destination: SearchResultsView(
                searchResultVM: SearchResultVMMock(scheduledDays: []),
                category: DrivingLicencesCategoriesConst.values.first!,
                wordId: String( 1),
                examType: ExamTypeEnum.practice
            ),
            destinationLabelText: "Szukaj",
            destinationLabelImage: "magnifyingglass",
            examTypeRequired: true
        )
    }
}
