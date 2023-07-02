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
    @State private var isShowingSheet = false


    var body: some View {
        Button(action: {
            isShowingSheet = true
        }) {
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
                .frame(width: 120)
                
                HStack {
                    Spacer()
                    
                    Group {
                        Image(systemName: "clock")
                        Text(formatDate(date:exam.date, formatFrom: "yyyy-MM-dd'T'HH:mm:ss", formatTo: "HH:mm"))
                    }
                    
                    Spacer()
                    
                    Group {
                        Image(systemName: "person")
                        Text(String(exam.places))
                    }
                    
                    Spacer()
                }
            }
            .listRowInsets(EdgeInsets())
        }
        .contentShape(Rectangle())
        .buttonStyle(.plain)
        .sheet(isPresented: $isShowingSheet) {
            Rectangle()
              .frame(width: 40, height: 6)
              .foregroundColor(.gray)
              .cornerRadius(3)
              .padding(.top, 6)
              .shadow(radius: 1)
              .padding(.bottom, 10)
            
            Spacer()

            ExamView(
                exam: exam,
                examType: examType,
                category: category
            )
            .presentationDetents([.fraction(0.40)])
            Spacer()
        }
    }
}

struct ExamRow_Previews: PreviewProvider {
    static var previews: some View {
        ExamRow(
            exam: ExamDTO(
                additionalInfo: nil,
                amount: 140,
                date: "2023-01-12T09:35:00",
                places: 2
            ),
            examType: ExamTypeEnum.practice,
            category: DrivingLicencesCategoriesConst.values.first!
        )
    }
}
