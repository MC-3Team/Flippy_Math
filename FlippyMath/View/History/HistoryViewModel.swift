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
        buttons = [
            ButtonData(title: "Button 1", imageName: "intro", destinationView: AnyView(QuestionViewWrapper(level: 0)), isPassed: true, questionIndex: 0),
            ButtonData(title: "Button 2", imageName: "teman", destinationView: AnyView(QuestionViewWrapper(level: 1)), isPassed: true, questionIndex: 1),
            ButtonData(title: "Button 3", imageName: "topi", destinationView: AnyView(QuestionViewWrapper(level: 2)), isPassed: true, questionIndex: 2),
            ButtonData(title: "Button 4", imageName: "balon", destinationView: AnyView(QuestionViewWrapper(level: 3)), isPassed: true, questionIndex: 3)
        ]
    }
    
    func clearNavigation() {
        activeButtonIndex = nil
    }
}
