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
    @State private var selectedDrivingCategory: DrivingLicenceCategory
    private let drivingLicenceCategories: [DrivingLicenceCategory]
    
    init() {
        drivingLicenceCategories = [
            DrivingLicenceCategory(id: "a", name: "A"),
            DrivingLicenceCategory(id: "a1", name: "A1"),
            DrivingLicenceCategory(id: "a2", name: "A2"),
            DrivingLicenceCategory(id: "am", name: "AM"),
            DrivingLicenceCategory(id: "b", name: "B"),
            DrivingLicenceCategory(id: "b1", name: "B1"),
            DrivingLicenceCategory(id: "b+e", name: "B+E"),
            DrivingLicenceCategory(id: "c", name: "C"),
            DrivingLicenceCategory(id: "c1", name: "C1"),
            DrivingLicenceCategory(id: "c+e", name: "C+E"),
            DrivingLicenceCategory(id: "c1+e", name: "C1+E"),
            DrivingLicenceCategory(id: "d", name: "D"),
            DrivingLicenceCategory(id: "d1", name: "D1"),
            DrivingLicenceCategory(id: "d+e", name: "D+E"),
            DrivingLicenceCategory(id: "d1+e", name: "D1+E"),
            DrivingLicenceCategory(id: "t", name: "T"),
            DrivingLicenceCategory(id: "pt", name: "PT"),
        ]
        
        selectedDrivingCategory = drivingLicenceCategories[0]
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
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
                    .onAppear() {
                        SearchVM.getProviences() { completion in
                            selectedProvince = SearchVM.proviencesDTO.provinces.first
                        }
                    }
                }

                Section {
                    Picker("Word", selection: $selectedWord) {
                        ForEach(SearchVM.sortedWords, id: \.self) { word in
                            Text(word.name).tag(word as Word?)
                        }
                    }
                }
                
                Section {
                    Picker("Kategoria", selection: $selectedDrivingCategory) {
                        ForEach(drivingLicenceCategories, id: \.self) {
                            Text($0.name)
                        }
                    }
                }
                if (selectedWord != nil) {
                    NavigationLink(
                        destination: SearchResultsView(
                            category: selectedDrivingCategory.id,
                            endDate: Date().addingTimeInterval(2419200).description,
                            startDate: Date().description,
                            wordId: String(selectedWord!.id)
                        )
                    ) {
                        Text("Szukaj")
                    }
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
