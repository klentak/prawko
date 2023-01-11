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
            Group {
                Image(systemName: "clock")
                Text(formatDate(
                    date: exam.date,
                    formatFrom: "yyyy-MM-dd'T'HH:mm:ss",
                    formatTo: "HH:mm")
                )
            }
            
            Group {
                Spacer()
                Image(systemName: "info.circle")
                Text(exam.additionalInfo ?? "-")
            }
            
            Spacer()
                
            Group {
                Image(systemName: "person")
                Text(String(exam.places))
            }
            
            Spacer()
            
            Group {
                Spacer()
                Image(systemName: "banknote")
                Text(String(exam.amount) + "zł")
                Spacer()
            }
        }
    }
}

struct ExamView_Previews: PreviewProvider {
    static var previews: some View {
        ExamView(
            exam: ExamDTO(
                additionalInfo: nil,
                amount: 23,
                date: "2022-10-26T18:28:10.727Z",
                places: 2
            ),
            examType: ExamTypeEnum.practice,
            category: DrivingLicencesCategoriesConst.values.first!
        )
    }
}
