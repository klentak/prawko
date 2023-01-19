//
//  NotificationRow.swift
//  prawko
//
//  Created by Jakub Klentak on 12/01/2023.
//

import SwiftUI

struct NotificationRowView: View {
    let watchlistElement : WatchlistElement
    let wordName : String
    
    var body: some View {
        HStack {
            VStack{
                HStack {
                    switch watchlistElement.type {
                    case ExamTypeEnum.theory:
                        Label("Teoria", systemImage: "doc.text")
                            .bold()
                    case ExamTypeEnum.practice:
                        Label("Praktyka", systemImage: watchlistElement.category.icon)
                            .bold()
                    case ExamTypeEnum.none:
                        Image(systemName: "x.circle.fill")
                    }
                }
                Text(
                    "Kategoria: " + watchlistElement.category.name
                )
                    .padding(.top)
                    .fontWeight(.light)
                
            }
            .frame(width: 140)
            
            Spacer()
            
            VStack {
                HStack {
                    Image(systemName: "clock")
                        .frame(width: 50)
                    VStack {
                        Text("Najbliższy termin:")
                            .bold()
                        Text(
                            (watchlistElement.latestExam?.date != nil)
                                ? formatDate(
                                    date: watchlistElement.latestExam!.date,
                                    formatFrom: "yyyy-MM-dd'T'HH:mm:ss",
                                    formatTo: "dd-MM-yyyy HH:mm"
                                ) : "-"
                        )
                    }
                }
                HStack {
                    Image(systemName: "house.and.flag")
                        .frame(width: 50)
                    VStack {
                        Text("Word:")
                            .bold()
                        
                        Text(wordName)
                    }
                }
                
                HStack {
                    
                }
            }
            
            Spacer()
        }
        .listRowInsets(EdgeInsets())
    }
}

struct NotificationRowView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationRowView(
            watchlistElement: WatchlistElement(
                category: DrivingLicencesCategoriesConst.values.first!,
                wordId: "1",
                type: ExamTypeEnum.practice,
                latestExam: ExamDTO(
                    additionalInfo: nil,
                    amount: 30,
                    date: "2023-03-18T16:38:16",
                    places: 3
                )
            ),
            wordName: "Testowa nazwa word"
        )
    }
}
