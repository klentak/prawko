//
//  ExamRow.swift
//  prawko
//
//  Created by Jakub Klentak on 04/01/2023.
//
import SwiftUI

struct ExamRow: View {
    let exam: Exam
    let examType: ExamTypeEnum
    let category: DrivingLicenceCategory
    
    @State private var sheetIsDisplayed = false


    var body: some View {
        Button(action: {
            sheetIsDisplayed = true
        }) {
            HStack {
                HStack {
                    switch examType {
                    case ExamTypeEnum.theory:
                        Image(systemName: "doc.text")
                            .frame(width: 40)
                        Text("Teoria")
                            .frame(width: 80)
                    case ExamTypeEnum.practice:
                        Image(systemName: category.icon)
                            .frame(width: 40)
                        Text("Praktyka")
                            .frame(width: 80)
                    case ExamTypeEnum.none:
                        Image(systemName: "car")
                    }
                }
                
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
        .sheet(isPresented: $sheetIsDisplayed) {
            generateSheet()
        }
    }
    
    private func generateSheet() -> some View {
        HStack {
            ExamView(
                exam: exam,
                examType: examType,
                category: category
            )
            .presentationDetents([.fraction(0.40)])
        }
        .presentationDragIndicator(.visible)
    }
}

struct ExamRow_Previews: PreviewProvider {
    static var previews: some View {
        ExamRow(
            exam: Exam(
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
