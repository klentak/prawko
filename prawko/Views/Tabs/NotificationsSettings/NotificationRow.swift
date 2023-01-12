//
//  NotificationRow.swift
//  prawko
//
//  Created by Jakub Klentak on 12/01/2023.
//

import SwiftUI

struct NotificationRow: View {
    let watchlistElement : WatchlistElement
    
    var body: some View {
        HStack {
            HStack {
                switch watchlistElement.type {
                case ExamTypeEnum.theory:
                    Text("Teoria")
                        .bold()
                case ExamTypeEnum.practice:
                    Text("Praktyka")
                        .bold()
                case ExamTypeEnum.none:
                    Image(systemName: "car")
                }
            }
            .frame(width: 140)
            
            Spacer()
            
            HStack {
                HStack {
                    Image(systemName: "clock")
                    VStack {
                        Text("Ostatni termin:")
                            .textCase(.lowercase)
                        Text(
                            (watchlistElement.latestExam != nil)
                            ? formatDate(date: watchlistElement.latestExam!.date, formatFrom: "yyyy-MM-dd'T'HH:mm:ss", formatTo: "dd-MM-yyyy HH:mm")
                            : "-"
                        )
                    }
                }
//                HStack {
//                    Image(systemName: "clock")
//                    VStack {
//                        Text("Ostatni termin:")
//                            .textCase(.lowercase)
//                        Text(watchlistElement.)
//                    }
//                }
            }
            
            Spacer()
        }
        .listRowInsets(EdgeInsets())
    }
}
