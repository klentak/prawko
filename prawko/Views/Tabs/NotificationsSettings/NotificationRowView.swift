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
            Group {
                switch watchlistElement.type {
                case ExamTypeEnum.theory:
                    Label("", systemImage: "doc.text")
                        .font(.largeTitle)
                case ExamTypeEnum.practice:
                    Label("", systemImage: watchlistElement.category.icon)
                        .font(.largeTitle)
                case ExamTypeEnum.none:
                    Image(systemName: "x.circle.fill")
                }
            }
            .padding(.leading, 15.0)
            
            VStack {
                Group {
                    Text(wordName)
                        .bold()
                    
                    switch watchlistElement.type {
                    case ExamTypeEnum.theory:
                        Text("Teoria")
                            .bold()
                    case ExamTypeEnum.practice:
                        Text("Praktyka")
                            .font(.subheadline)
                    case ExamTypeEnum.none:
                        Image(systemName: "x.circle.fill")
                    }
                    
                    Text("Najbliższy termin:")
                        .font(.caption)
                    
                    Text(
                        (watchlistElement.latestExam?.date != nil)
                        ? formatDate(
                            date: watchlistElement.latestExam!.date,
                            formatTo: "dd-MM-yyyy HH:mm"
                        ) : "-"
                    )
                    .font(.caption)
                }
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
        }
        .padding(.vertical, 4.0)
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
                latestExam: Exam(
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
