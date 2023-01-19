//
//  ExamView.swift
//  prawko
//
//  Created by Jakub Klentak on 09/01/2023.
//

import SwiftUI

struct ExamView: View {
    let exam: ExamDTO
    let examType: ExamTypeEnum
    let category: DrivingLicenceCategory

    var body: some View {
        VStack {
            Text(examType.rawValue)
                .font(.largeTitle)
                .textCase(.uppercase)
            Spacer()
            HStack {
                Label("", systemImage: "calendar")
                    .bold()
                Text(
                    formatDate(
                        date: exam.date,
                        formatFrom: "yyyy-MM-dd'T'HH:mm:ss",
                        formatTo: "dd-MM-yyyy HH:mm"
                    )
                )
                .bold()
            }
            
            Spacer()
            
            HStack {
                Label("Informacje: ", systemImage: "info.circle")
                Text(exam.additionalInfo ?? "-")
            }
            
            Spacer()
                
            HStack {
                Label("Miejsc: ", systemImage: "person")
                Text(String(exam.places))
            }
            
            Spacer()
            
            HStack {
                Label("Cena", systemImage: "banknote")
                Text(String(exam.amount) + "zł")
            }
            Spacer()
        }
        .frame(height: 200)
    }
}

struct ExamView_Previews: PreviewProvider {
    static var previews: some View {
        ExamView(
            exam: ExamDTO(
                additionalInfo: nil,
                amount: 23,
                date: "2022-10-26T18:28:10",
                places: 2
            ),
            examType: ExamTypeEnum.practice,
            category: DrivingLicencesCategoriesConst.values.first!
        )
    }
}
