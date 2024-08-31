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
    
    @Published var snowflakes: [Snowflake] = []
    @Published var animate = false

    private let numberOfSnowflakes = 75

    init() {
        loadQuestions()
    }
    
    func loadQuestions() {
        let questions = CoreDataManager().getAllQuestion()
        buttons = questions.map { question in
          ButtonData(
                title: "Level \(question.sequence)",
                imageName: question.historyLevel ?? "",
                destinationView: AnyView(QuestionViewWrapper(sequenceLevel: Int(Int64(question.sequence)), parameter: .history)),
                isPassed: question.is_complete,
                sequence: question.sequence
            )
        }
    }
    
    func createSnowflakes(in size: CGSize) {
        snowflakes.removeAll()
        for _ in 0..<numberOfSnowflakes {
            let xPosition = CGFloat.random(in: 0...size.width)
            let duration = Double.random(in: 5...15)
            let delay = Double.random(in: 0...20)
            let snowflakeSize = CGFloat.random(in: 10...30)
            let imageName = Bool.random() ? "snow1" : "snow2"
            let rotationDuration = Double.random(in: 3...10)
            let snowflake = Snowflake(xPosition: xPosition, duration: duration, delay: delay, size: snowflakeSize, imageName: imageName, rotationDuration: rotationDuration)
            snowflakes.append(snowflake)
        }
    }
    
    func clearNavigation() {
        activeButtonIndex = nil
    }
}
