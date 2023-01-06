//
//  Search.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI

struct SearchView: View {
    @StateObject var SearchVM = SearchViewModel()
    
    @State private var selectedWord: Word? = nil
    @State private var selectedProvince: Province? = nil
    @State private var selectedDrivingCategory: DrivingLicenceCategory = DrivingLicencesCategoriesConst.values.first!
    @State private var selectedExamType: ExamTypeEnum = .none
    
    var body: some View {
        NavigationView {
            if (!SearchVM.proviencesDTO.words.isEmpty) {
                Form {
                    Section(header: Text("Województwo")) {
                        Picker("Województwo", selection: $selectedProvince) {
                            ForEach(SearchVM.proviencesDTO.provinces, id: \.self) { province in
                                Text(province.name).tag(province as Province?)
                            }
                        }
                        .onChange(of: selectedProvince) { _ in
                            if (selectedProvince != nil) {
                                SearchVM.sortWords(province: selectedProvince!) { completion in
                                    selectedWord = SearchVM.sortedWords.first
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Ośrodek egzaminacyjny")) {
                        Picker("Word", selection: $selectedWord) {
                            ForEach(SearchVM.sortedWords) {
                                Text($0.name).tag($0 as Word?)
                            }
                        }
                    }
                    
                    Section(header: Text("Kategoria prawa jazdy")) {
                        Picker("Kategoria", selection: $selectedDrivingCategory) {
                            ForEach(DrivingLicencesCategoriesConst.values, id: \.id) {
                                Text($0.name).tag($0 as DrivingLicenceCategory)
                            }
                        }
                    }
                    
                    Section(header: Text("Rodaj egzaminu")) {
                        Picker("Rodaj", selection: $selectedExamType) {
                            ForEach(ExamTypeEnum.allCases) { value in
                                Text(value.rawValue)
                                    .tag(value)
                            }
                        }
                    }
                    
                    NavigationLink(
                        destination: SearchResultsView(
                            category: selectedDrivingCategory,
                            wordId: String(selectedWord?.id ?? 1),
                            examType: selectedExamType
                        )
                    ) {
                        Text("Szukaj")
                    }
                    .disabled(selectedProvince == nil)
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(3)
            }
        }
        .onAppear() {
            SearchVM.getProviences() { completion in
                selectedProvince = SearchVM.proviencesDTO.provinces.first!
                SearchVM.sortWords(province: selectedProvince!) { _ in
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
