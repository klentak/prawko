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
    @State private var selectedDrivingCategory: DrivingLicenceCategory? = nil
    @State private var selectedExamType: ExamTypeEnum = .none
    
    let notificationView : Bool
    
    var body: some View {
        NavigationView {
            if (!SearchVM.proviencesDTO.words.isEmpty) {
                VStack {
                    Form {
                        Section(header: Text("Województwo")) {
                            Picker("Województwo", selection: $selectedProvince) {
                                if (selectedProvince == nil) {
                                    Text("").tag(Optional<String>(nil))
                                }
                                ForEach(SearchVM.proviencesDTO.provinces, id: \.self) { province in
                                    Text(province.name).tag(province as Province?)
                                }
                            }
                            .onChange(of: selectedProvince) { _ in
                                if (selectedProvince != nil) {
                                    SearchVM.sortWords(province: selectedProvince!) { _ in
                                    }
                                    selectedWord = nil
                                }
                            }
                        }
                        
                        Section(header: Text("Ośrodek egzaminacyjny")) {
                            Picker("Word", selection: $selectedWord) {
                                if (selectedWord == nil) {
                                    Text("").tag(Optional<String>(nil))
                                }
                                ForEach(SearchVM.sortedWords) {
                                    Text($0.name).tag($0 as Word?)
                                }
                            }
                        }
                        
                        Section(header: Text("Kategoria prawa jazdy")) {
                            Picker("Kategoria", selection: $selectedDrivingCategory) {
                                if (selectedDrivingCategory == nil) {
                                    Text("").tag(Optional<String>(nil))
                                }
                                ForEach(DrivingLicencesCategoriesConst.values, id: \.id) {
                                    Text($0.name).tag($0 as DrivingLicenceCategory?)
                                }
                            }
                        }
                        
                        Section(header: Text("Rodzaj egzaminu")) {
                            Picker("Rodzaj", selection: $selectedExamType) {
                                ForEach(ExamTypeEnum.allCases) { value in
                                    Text(value.rawValue)
                                        .tag(value)
                                }
                            }
                        }
                        
                        if (notificationView) {
                            NavigationLink(
                                destination: NotificationsSettingsAddResultView(
                                    category: selectedDrivingCategory ?? DrivingLicencesCategoriesConst.values.first!,
                                    wordId: String(selectedWord?.id ?? 1),
                                    type: selectedExamType
                                )
                            ) {
                                Label("Dodaj do obserwowanych", systemImage: "plus")
                            }
                            .disabled(isNotificationsSettingsAddResultViewNavigationLiskDisabled())
                        } else {
                            NavigationLink(
                                destination: SearchResultsView(
                                    category: selectedDrivingCategory ?? DrivingLicencesCategoriesConst.values.first!,
                                    wordId: String(selectedWord?.id ?? 1),
                                    examType: selectedExamType
                                )
                            ) {
                                Label("Szukaj", systemImage: "magnifyingglass")
                            }
                            .disabled(isSearchResultsViewNavigationLiskDisabled())
                        }
                    }
                }
                .scrollDisabled(true)
                .navigationTitle(Text("Szukaj"))
                .navigationBarHidden(notificationView)
            } else {
                CommonProgressView()
            }
        }
        .onAppear() {
            SearchVM.getProviences() { completion in
            }
        }
    }
    
    func isNotificationsSettingsAddResultViewNavigationLiskDisabled() -> Bool {
        return selectedProvince == nil
            || selectedWord == nil
            || selectedDrivingCategory == nil
            || selectedExamType == ExamTypeEnum.none
    }
    
    func isSearchResultsViewNavigationLiskDisabled() -> Bool {
        return selectedProvince == nil
            || selectedWord == nil
            || selectedDrivingCategory == nil
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(notificationView: false)
    }
}
