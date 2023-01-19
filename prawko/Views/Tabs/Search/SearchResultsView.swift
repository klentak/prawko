//
//  SearchResultsView.swift
//  prawko
//
//  Created by Jakub Klentak on 24/12/2022.
//

import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var searchResultVM = SearchResultViewModel() 
    @State var loading = true
    @State var downloadDataAlert = false
    
    let category : DrivingLicenceCategory
    let wordId : String
    let examType : ExamTypeEnum
    
    var body: some View {
        VStack {
            if (loading) {
                CommonProgressView()
            } else if (searchResultVM.noResultsByExamType(examType: examType)) {
                HStack {
                    Label {
                        Text("Brak terminów :(")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                    } icon: {
                        // Put the "image" here
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                    }.labelStyle(VerticalLabelStyle())
                }
            } else {
                List {
                    ForEach(searchResultVM.scheduledDays) { scheduledDay in
                        if (searchResultVM.showGroup(scheduleDay: scheduledDay, examType: examType)) {
                            DisclosureGroup(
                                formatDate(
                                    date: scheduledDay.day,
                                    formatFrom: "yyyy-MM-dd",
                                    formatTo: "E, dd.MM"
                                )
                            ) {
                                ForEach(scheduledDay.scheduledHours) { scheduledHour in
                                    switch examType {
                                    case .practice:
                                        ForEach(scheduledHour.practiceExams) { practiceExam in
                                            ExamRow(exam: practiceExam, examType: ExamTypeEnum.practice, category: category
                                            )
                                        }
                                    case .theory:
                                        ForEach(scheduledHour.theoryExams) { theoryExam in
                                            ExamRow(exam: theoryExam, examType: ExamTypeEnum.theory, category: category
                                            )
                                        }
                                    case .none:
                                        ForEach(scheduledHour.theoryExams) { theoryExam in
                                            ExamRow(exam: theoryExam, examType: ExamTypeEnum.theory, category: category
                                            )
                                        }
                                        
                                        ForEach(scheduledHour.practiceExams) { practiceExam in
                                            ExamRow(exam: practiceExam, examType: ExamTypeEnum.practice, category: category
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(SidebarListStyle())
            }
        }
        .onAppear {
            searchResultVM.getScheduledDays(
                category: category,
                wordId: wordId
            ) { completion in
                if (completion) {
                    loading = false
                } else {
                    downloadDataAlert = true
                }
            }
        }
        .alert(isPresented: $downloadDataAlert) {
            Alert(
                title: Text("Błąd systemu info-share"),
                message: Text("Spróbuj ponownie później"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(
            category: DrivingLicencesCategoriesConst.values.first!,
            wordId: "2",
            examType: ExamTypeEnum.theory
        )
    }
}
