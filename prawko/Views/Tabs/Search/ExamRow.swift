//
//  ExamRow.swift
//  prawko
//
//  Created by Jakub Klentak on 04/01/2023.
//

import SwiftUI

struct ExamRow: View {
    let exam: ExamDTO
    let examType: ExamTypeEnum
    let category: DrivingLicenceCategory

    var body: some View {
        VStack {
            HStack {
                switch examType {
                case ExamTypeEnum.theory:
                    Label("Teoria", systemImage: "doc.text")
                        .font(.largeTitle)
                case ExamTypeEnum.practice:
                    Label("Praktyka", systemImage: category.icon)
                        .font(.largeTitle)
                case ExamTypeEnum.none:
                    Image(systemName: "car")
                }
            }
            .frame(width: 120)
            
            Spacer()

            Group {
                Label("Dnia", systemImage: "calendar")
                Text(formatDate(
                    date: exam.date,
                    formatFrom: "yyyy-MM-dd'T'HH:mm:ss",
                    formatTo: "dd.MM-yyyy, HH:mm"
                ))
                .bold()
            }
                
            Spacer()
                
            Group {
                Label("Wolnych miejsc", systemImage: "person")
                Text(String(exam.places))
                    .bold()
            }
            
            Spacer()
                
            Group {
                Label("Cena", systemImage: "banknote")
                Text(String(exam.amount) + " zł")
                    .bold()
            }
            Spacer()
        }
        .frame(width: 500, height: 200)
    }
}

struct ExamRow_Previews: PreviewProvider {
    static var previews: some View {
        ExamRow(
            exam: ExamDTO(additionalInfo: nil, amount: 140, date: "2023-01-12T09:35:00", places: 2),
            examType: ExamTypeEnum.practice,
            category: DrivingLicencesCategoriesConst.values.first!
        )
    }
}
