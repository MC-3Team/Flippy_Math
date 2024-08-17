//
//  HistoryView.swift
//  FlippyMath
//
//  Created by William Handoko on 17/08/24.
//

import SwiftUI

struct QuestionViewWrapper: View {
    let level: Int
    
    var body: some View {
        QuestionView(viewModel: QuestionViewModel(level: level))
    }
}
