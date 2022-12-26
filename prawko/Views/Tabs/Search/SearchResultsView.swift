//
//  SearchResultsView.swift
//  prawko
//
//  Created by Jakub Klentak on 24/12/2022.
//

import SwiftUI

struct SearchResultsView: View {
    @StateObject var SearchResultVM = SearchResultViewModel()
    
    let category : String
    let endDate : String
    let startDate : String
    let wordId : String
    
    var body: some View {
        VStack {
            if (SearchResultVM.scheduledDays.isEmpty) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(3)
            } else {
                Text("loaded")
            }
        }
        .onAppear {
            SearchResultVM.getScheduledDays(
                category: category,
                startDate: startDate,
                endDate: endDate,
                wordId: wordId
            )
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(
            category: "B",
            endDate: Date().description,
            startDate: Date().addingTimeInterval(2419200).description,
            wordId: "2"
        )
    }
}
