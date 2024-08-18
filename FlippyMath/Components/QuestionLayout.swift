//
//  QuestionLayout.swift
//  FlippyMath
//
//  Created by Rajesh Triadi Noftarizal on 13/08/24.
//

import SwiftUI

struct QuestionLayout<Content: View>: View {
    @ObservedObject var viewModel: QuestionViewModel
    @Environment(\.dismiss) var dismiss
    
    let children: (GeometryProxy) -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(viewModel.currentQuestionData.background)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Button {
                    self.dismiss()
                } label: {
                    Image("HomeButton")
                        .resizable()
                        .frame(width: geometry.size.width * 0.11, height: geometry.size.height * 0.15)
                }
                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)

                children(geometry)

                HStack {
                    
                    FlippyRiveView(riveInput: $viewModel.riveInput)
                        .frame(width: geometry.size.width * 1.0, height: geometry.size.height * 0.35)
                        .position(x: geometry.size.width * 0.07, y: geometry.size.height * 0.935)

                    ZStack(alignment: .leading) {
                        Image("MessagePlaceholder")
                            .resizable()
                            .frame(width: geometry.size.width * 0.7, height: geometry.size.height * 0.13)

                        TypewriterText(fullText: Binding(
                            get: {
                                viewModel.apretiation.isEmpty ? viewModel.currentQuestionData.stories[viewModel.currentMessageIndex].story : viewModel.apretiation
                            },
                            set: { _ in }
                        ), audioName: Binding(
                            get: {
                                viewModel.apretiation.isEmpty ? viewModel.currentQuestionData.stories[viewModel.currentMessageIndex].audio : viewModel.currentQuestionData.stories[viewModel.currentMessageIndex].audio_apretiation
                            },
                            set: { _ in }
                        ), onComplete: {
                            viewModel.riveInput = [FlippyRiveInput(key: .talking, value: FlippyValue.float(0.0)),
                                                   FlippyRiveInput(key: .isRightHandsUp, value: .bool(false))]
                        }).id(viewModel.repeatQuestion)
                            .font(.custom("PilcrowRoundedVariable-Regular", size: 34))
                            .fontWeight(.bold)
                            .padding(.leading, 80)
                            .padding(.trailing, 10)
                            .lineLimit(nil)
                            .frame(width: geometry.size.width * 0.7, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                    .position(x: geometry.size.width * 0.14, y: geometry.size.height * 0.94)

                    Button(action: {
                        viewModel.checkAnswerAndAdvance()
                    }, label: {
                        Image(viewModel.currentQuestionData.problems != [] ? viewModel.currentQuestionData.problems[viewModel.currentMathIndex].isQuestion ? (viewModel.userAnswer.isEmpty ? "CorrectButtonGray" : "CorrectButton") :  "NextButton" : "NextButton")
                            .resizable()
                            .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                    })
                    .position(x: geometry.size.width * 0.23, y: geometry.size.height * 0.955)
                    .disabled(viewModel.currentQuestionData.problems != [] ? viewModel.currentQuestionData.problems[viewModel.currentMathIndex].isQuestion && viewModel.userAnswer.isEmpty : false)
                }

                Text(displayMathProblems())
                    .font(.custom("PilcrowRoundedVariable-Regular", size: 180))
                    .fontWeight(.heavy)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.25)
            }
        }
    }
    
    func displayMathProblems() -> AttributedString {
        let problems = viewModel.currentQuestionData.problems
        var attributedString = AttributedString("")
        var index = 0

        while index <= viewModel.currentMathIndex && index < problems.count {
            let problem = problems[index]
            var problemString = problem.isQuestion && index == viewModel.currentMathIndex ? viewModel.userAnswer.isEmpty ? "?" : viewModel.userAnswer : problem.problem
            problemString += " "
            
            var attributedProblem = AttributedString(problemString)
            
            if let uiColor = UIColor(named: problem.color) {
                attributedProblem.foregroundColor = Color(uiColor)
            } else {
                attributedProblem.foregroundColor = .primary
            }

            attributedString.append(attributedProblem)
    
            if problem.isOperator {
                
                if (index + 1) < problems.count {
                    let nextProblem = problems[index + 1]
                    var nextProblemString = nextProblem.problem
                    
                    if nextProblem.isQuestion {
                        nextProblemString = viewModel.userAnswer.isEmpty ? "?" : viewModel.userAnswer
                    }
                    
                    nextProblemString += " "
                    
                    var attributedNextProblem = AttributedString(nextProblemString)
                    
                    if let uiColor = UIColor(named: nextProblem.color) {
                        attributedNextProblem.foregroundColor = Color(uiColor)
                    } else {
                        attributedNextProblem.foregroundColor = .primary
                    }

                    attributedString.append(attributedNextProblem)
                    index += 1
                }
            }

            index += 1
        }

        return attributedString
    }

}

#Preview {
    QuestionLayout(
        viewModel: QuestionViewModel(level: 2), // Replace with your desired level or mock data
        children: { geometry in
            // Example of content you might want to preview within the layout
            VStack {
                Text("Preview Content")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue.opacity(0.3))
            }
        }
    )
}
