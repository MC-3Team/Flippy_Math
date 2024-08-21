//
//  HistoryViewModel.swift
//  FlippyMath
//
//  Created by William Handoko on 17/08/24.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var buttons: [ButtonData] = []
    @Published var activeButtonIndex: Int? = nil
    
    init() {
        loadQuestions()
    }
    
    func loadQuestions() {
        let questions = CoreDataManager().getAllQuestion()
        buttons = questions.map { question in
          ButtonData(
                title: "Level \(question.sequence)",
                imageName: question.historyLevel!,
                destinationView: AnyView(QuestionViewWrapper(sequenceLevel: Int(Int64(question.sequence)), parameter: .history)),
                isPassed: question.is_complete,
                sequence: question.sequence
            )
        }
    }
    
    func clearNavigation() {
        activeButtonIndex = nil
    }
}
