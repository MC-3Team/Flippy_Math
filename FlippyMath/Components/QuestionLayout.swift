//
//  QuestionLayout.swift
//  FlippyMath
//
//  Created by Rajesh Triadi Noftarizal on 13/08/24.
//

import SwiftUI

struct QuestionLayout<Content: View>: View {
    @ObservedObject var viewModel: QuestionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let children: (GeometryProxy) -> Content
    @State private var textPositions: [Int: CGPoint] = [:]
    
    init(viewModel: QuestionViewModel, @ViewBuilder children: @escaping (GeometryProxy) -> Content) {
          self.viewModel = viewModel
          self.children = children
      }
    @State private var currentImage: String = ""
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(currentImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("HomeButton")
                        .resizable()
                        .frame(width: geometry.size.width * 0.11, height: geometry.size.height * 0.15)
                }
                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
                
                children(geometry)
                
                HStack {
                    ForEach(getMathProblems(), id: \.0) { (sequence, problemString, isQuestion, problemColor) in
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                let isCurrentQuestion = isQuestion && viewModel.userAnswer.isEmpty

                                Text(problemString)
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 180))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color(problemColor))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, isCurrentQuestion ? 0 : 16)
                                    .background(
                                        GeometryReader { geo in
                                            Color.clear.onAppear {
                                                if isCurrentQuestion {
                                                    let globalPosition = geo.frame(in: .global).origin
                                                    DispatchQueue.main.async {
                                                        textPositions[sequence] = globalPosition
                                                    }
                                                }
                                            }
                                        }
                                        .frame(width: 0, height: 0)
                                    )
                                    .onChange(of: viewModel.userAnswer) { _ , _ in
                                        if !viewModel.userAnswer.isEmpty {
                                            DispatchQueue.main.async {
                                                textPositions.removeAll()
                                            }
                                        }
                                    }
                                            
                                if isCurrentQuestion {
                                    Spacer().frame(height: 16)
                                }
                            }
                            
                        }
                    }.id(viewModel.repeatProblem)
                }
                .frame(width: geometry.size.width * 0.9)
                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.25)
                
                ForEach(Array(textPositions.keys.sorted()), id: \.self) { key in
                    if let position = textPositions[key] {
                        HStack(spacing: 4) {
                            Image(uiImage: (!viewModel.currentQuestionData.problems[viewModel.currentMathIndex].isSpeech ? UIImage(named: "handClap") : UIImage(systemName: "wave.3.right"))!)
                            Text(!viewModel.currentQuestionData.problems[viewModel.currentMathIndex].isSpeech ? "Tepukkan tangan" : "Sebutkan angka")
                                .font(.callout)
                                .fontWeight(.bold)
                            Text(!viewModel.currentQuestionData.problems[viewModel.currentMathIndex].isSpeech ? "untuk memunculkan angka" : "untuk menjawab")
                                .font(.callout)
                        }
                        .padding(.top, 32)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 16)
                        .foregroundColor(.black)
                        .background(
                            ChatBubbleShape()
                                .fill(Color.white)
                        )
                        .position(x: position.x + 4 , y: position.y + 96)
                    }
                }
                
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
                            .padding(.bottom, 10)
                            .lineLimit(nil)
                            .frame(width: geometry.size.width * 0.7, alignment: .leading)
                            .multilineTextAlignment(.leading)
                    }
                    .position(x: geometry.size.width * 0.14, y: geometry.size.height * 0.94)
                    
                    Button(action: {
                        viewModel.checkAnswerAndAdvance()
                    }, label: {
                        Image(!viewModel.apretiation.isEmpty ? "NextButton" : (viewModel.currentQuestionData.problems != [] ? viewModel.currentQuestionData.problems[viewModel.currentMathIndex].isQuestion ? (viewModel.userAnswer.isEmpty ? "CorrectButtonGray" : "CorrectButton") : "NextButton" : "NextButton"))
                            .resizable()
                            .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                    })
                    .position(x: geometry.size.width * 0.23, y: geometry.size.height * 0.955)
                    .disabled(viewModel.currentQuestionData.problems != [] ? viewModel.currentQuestionData.problems[viewModel.currentMathIndex].isQuestion && viewModel.userAnswer.isEmpty : false)
                }
            }
        }.onAppear {
            currentImage = viewModel.currentQuestionData.background
        }
        .onChange(of: viewModel.currentQuestionData) {_, _ in
            currentImage = viewModel.currentQuestionData.background
        }
        .onDisappear {
            currentImage = ""
        }
    }
    
    
    func getMathProblems() -> [(Int, String, Bool, String)] {
        let problems = viewModel.currentQuestionData.problems
        var problemData: [(Int, String, Bool, String)] = []
        
        var index = 0
        while index <= viewModel.currentMathIndex && index < problems.count {
            let problem = problems[index]
            var problemString = ""
            if problem.isQuestion {
                let isQuestion = index == viewModel.currentMathIndex && viewModel.userAnswer.isEmpty
                problemString = isQuestion ? "?" : (index < viewModel.currentMathIndex) ? problem.problem : viewModel.userAnswer
            } else {
                problemString = problem.problem
            }
            let isQuestion = problem.isQuestion && index == viewModel.currentMathIndex && viewModel.userAnswer.isEmpty
            let problemColor = problem.color
            let sequencial = problem.sequence
            problemData.append((sequencial, problemString, isQuestion, problemColor))
            
            if problem.isOperator {
                if (index + 1) < problems.count {
                    let nextProblem = problems[index + 1]
                    var nextProblemString = ""
                    if nextProblem.isQuestion {
                        let isQuestion = (index + 1) == viewModel.currentMathIndex && viewModel.userAnswer.isEmpty
                        nextProblemString = isQuestion ? "?" : index + 1 < viewModel.currentMathIndex ? nextProblem.problem : viewModel.userAnswer
                    } else {
                        nextProblemString = nextProblem.problem
                    }
                    
                    problemData.append((nextProblem.sequence, nextProblemString, nextProblem.isQuestion, nextProblem.color))
                    index += 1
                }
            }
            
            index += 1
        }
        
        return problemData
    }
    
    
}

//#Preview {
//    QuestionLayout(
//        viewModel: QuestionViewModel(level: 2), // Replace with your desired level or mock data
//        children: { geometry in
//            // Example of content you might want to preview within the layout
//            VStack {
//                Text("Preview Content")
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color.blue.opacity(0.3))
//            }
//        }
//    )
//}
