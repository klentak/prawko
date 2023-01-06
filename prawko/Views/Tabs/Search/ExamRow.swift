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
        HStack {
            HStack {
                switch examType {
                case ExamTypeEnum.theory:
                    Image(systemName: "doc.text")
                    Text("Teoria |")
                case ExamTypeEnum.practice:
                    Image(systemName: category.icon)
                    Text("Praktyka |")
                case ExamTypeEnum.none:
                    Image(systemName: "car")
                }
            }
            HStack {
                Group {
                    Spacer()
                    Image(systemName: "clock")
                    Text(formatDate(date:exam.date, formatFrom: "yyyy-MM-dd'T'HH:mm:ss", formatTo: "HH:mm"))
                }
                
                
//                Group {
//                    Spacer()
//                    Image(systemName: "info.circle")
//                    Text(exam.additionalInfo ?? "-")
//                }
                
                Group {
                    Spacer()
                    Image(systemName: "person")
                    Text(String(exam.places))
                    Spacer()
                }
                
//                Group {
//                    Spacer()
//                    Image(systemName: "banknote")
//                    Text(String(exam.amount) + "zł")
//                    Spacer()
//                }
            }
        }
        .listRowInsets(EdgeInsets())
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
