//
//  HistoryView.swift
//  FlippyMath
//
//  Created by William Handoko on 17/08/24.
//

import SwiftUI

struct QuestionViewWrapper: View {
    var sequenceLevel: Int
    var parameter : Parameter
    
    var body: some View {
        QuestionView(viewModel: QuestionViewModel(sequenceLevel: sequenceLevel, parameter: parameter))
    }
}


enum Parameter {
    case home
    case history
}
