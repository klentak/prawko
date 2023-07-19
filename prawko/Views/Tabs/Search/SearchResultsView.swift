//
//  SearchResultsView.swift
//  prawko
//
//  Created by Jakub Klentak on 24/12/2022.
//

import SwiftUI

struct SearchResultsView<ViewModel>: View where ViewModel: SearchResultVMProtocol {
    @ObservedObject var searchResultVM: ViewModel

    @State var loading: Bool
    @State var downloadDataAlert: Bool
    
    let category: DrivingLicenceCategory
    let wordId: String
    let examType: ExamTypeEnum
    
    init(
        searchResultVM: ViewModel,
        category: DrivingLicenceCategory,
        wordId: String,
        examType: ExamTypeEnum
    ) {
        self.searchResultVM = searchResultVM
        self.loading = true
        self.downloadDataAlert = false
        self.category = category
        self.wordId = wordId
        self.examType = examType
    }
    
    var body: some View {
        VStack {
            if (loading) {
                CommonProgressView()
            } else if (searchResultVM.noResultsByExamType(examType: examType)) {
                noResultsView()
            } else {
                examList()
            }
        }
        .onAppear {
            searchResultVM.getScheduledDays(
                category: category,
                wordId: wordId
            ) { completion in
                downloadDataAlert = !completion
                loading = false
            }
        }
        .alert(isPresented: $downloadDataAlert) {
            generateAlert()
        }
    }
    
    private func noResultsView() -> some View {
        return HStack {
            Label {
                Text("Brak terminów :(")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            } icon: {
                // Put the "image" here
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            }
            .labelStyle(VerticalLabelStyle())
        }
    }
    
    private func examList() -> some View {
        List {
            ForEach(searchResultVM.scheduledDays) { scheduledDay in
                if (
                    searchResultVM.showDayGroup(
                        scheduleDay: scheduledDay,
                        examType: examType
                    )
                ) {
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
                                    ExamRow(exam: practiceExam, examType: ExamTypeEnum.practice, category: category)
                                }
                            case .theory:
                                ForEach(scheduledHour.theoryExams) { theoryExam in
                                    ExamRow(exam: theoryExam, examType: ExamTypeEnum.theory, category: category)
                                }
                            case .none:
                                ForEach(scheduledHour.theoryExams) { theoryExam in
                                    ExamRow(exam: theoryExam, examType: ExamTypeEnum.theory, category: category)
                                }

                                ForEach(scheduledHour.practiceExams) { practiceExam in
                                    ExamRow(exam: practiceExam, examType: ExamTypeEnum.practice, category: category)
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
    
    private func generateAlert() -> Alert {
        return Alert(
            title: Text("Błąd systemu info-share"),
            message: Text("Spróbuj ponownie później"),
            dismissButton: .default(Text("OK"))
        )
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        let exam = Exam(
            additionalInfo: nil,
            amount: 2,
            date: "2023-01-12T16:30:00",
            places: 2
        )
        
        Group {
            SearchResultsView(
                searchResultVM: SearchResultVMMock(
                    scheduledDays: []
                ),
                category: DrivingLicencesCategoriesConst.values.first!,
                wordId: "2",
                examType: ExamTypeEnum.none
            )

            SearchResultsView(
                searchResultVM: SearchResultVMMock(
                    scheduledDays: [
                        ScheduleDay(
                            day: "2023-03-03",
                            scheduledHours: [
                                ScheduledHours(
                                    practiceExams: [
                                        exam
                                    ],
                                    theoryExams: [
                                        exam
                                    ],
                                    time: "16:30:00"
                                )
                            ]
                        ),
                        ScheduleDay(
                            day: "2023-03-03",
                            scheduledHours: [
                                ScheduledHours(
                                    practiceExams: [
                                        exam,
                                    ],
                                    theoryExams: [
                                        exam,
                                    ],
                                    time: "16:30:00"
                                ),
                                ScheduledHours(
                                    practiceExams: [
                                        exam,
                                    ],
                                    theoryExams: [
                                        exam,
                                    ],
                                    time: "16:40:00"
                                ),
                                ScheduledHours(
                                    practiceExams: [
                                        exam,
                                    ],
                                    theoryExams: [
                                        exam,
                                    ],
                                    time: "16:50:00"
                                )
                            ]
                        )
                    ]
                ),
                category: DrivingLicencesCategoriesConst.values.first!,
                wordId: "2",
                examType: ExamTypeEnum.none
            )
            
            SearchResultsView(
                searchResultVM: SearchResultVMMockWithError(
                    scheduledDays: []
                ),
                category: DrivingLicencesCategoriesConst.values.first!,
                wordId: "2",
                examType: ExamTypeEnum.none
            )
        }
    }
}
