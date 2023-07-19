//
//  ExamView.swift
//  prawko
//
//  Created by Jakub Klentak on 09/01/2023.
//

import SwiftUI

struct ExamView: View {
    let exam: Exam
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
                    .frame(width: 20)
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
            .frame(width: 180)
            
            Spacer()
            
            HStack {
                Image(systemName: "info.circle")
                    .frame(width: 20)
                Label("Informacje: ", systemImage: "")
                Text(exam.additionalInfo ?? "-")
                Spacer()
            }
            .frame(width: 180)
            
            Spacer()
                
            HStack {
                Image(systemName: "person")
                    .frame(width: 20)
                Label("Miejsc: ", systemImage: "")
                Text(String(exam.places))
                Spacer()
            }
            .frame(width: 180)
            
            Spacer()
            
            HStack {
                Image(systemName: "banknote")
                    .frame(width: 20)
                Label("Cena", systemImage: "")
                Text(String(exam.amount) + "zł")
                Spacer()
            }
            .frame(width: 180)

        }
        .frame(height: 200)
    }
}

struct ExamView_Previews: PreviewProvider {
    static var previews: some View {
        ExamView(
            exam: Exam(
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
