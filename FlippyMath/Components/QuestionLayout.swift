//
//  QuestionLayout.swift
//  BambiniMath
//
//  Created by Rajesh Triadi Noftarizal on 13/08/24.
//

import SwiftUI

struct QuestionLayout<Content: View>: View {
    @ObservedObject var viewModel: QuestionViewModel
    @Environment(\.dismiss) var dismiss
    
    let children: (GeometryProxy) -> Content
    @State private var textPositions: [Int: CGPoint] = [:]
    
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
                    ForEach(getMathProblems(), id: \.0) { (sequence, problemString, isQuestion, problemColor) in
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                // Step 1: Initial logic, will run first
                                let isCurrentQuestion = isQuestion && viewModel.userAnswer.isEmpty
                                let _ = print("ATAS \(problemString)") // This runs first
                                
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
                                                    print("QUESTION")
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
                                            print("TIDAK EMPTY")
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
                            Image(systemName: "wave.3.right")
                            Text("Sebutkan angka")
                                .font(.callout)
                                .fontWeight(.bold)
                            Text("untuk menjawab")
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
                    BambiniRiveView(riveInput: $viewModel.riveInput)
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
                            viewModel.riveInput = [BambiniRiveInput(key: .talking, value: BambiniValue.float(0.0)),
                                                   BambiniRiveInput(key: .isRightHandsUp, value: .bool(false))]
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
                        Image(viewModel.currentQuestionData.problems[viewModel.currentMathIndex].isQuestion ? (viewModel.userAnswer.isEmpty ? "CorrectButtonGray" : "CorrectButton") : "NextButton")
                            .resizable()
                            .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                    })
                    .position(x: geometry.size.width * 0.23, y: geometry.size.height * 0.955)
                    .disabled(viewModel.currentQuestionData.problems[viewModel.currentMathIndex].isQuestion && viewModel.userAnswer.isEmpty)
                }
            }
        }
    }
    
    
    func getMathProblems() -> [(Int, String, Bool, String)] {
        let problems = viewModel.currentQuestionData.problems
        var problemData: [(Int, String, Bool, String)] = []
        
        var index = 0
        while index <= viewModel.currentMathIndex && index < problems.count {
            let problem = problems[index]
            let isQuestion = problem.isQuestion && index == viewModel.currentMathIndex && viewModel.userAnswer.isEmpty
            let problemString = isQuestion ? "?" : problem.problem
            let problemColor = problem.color
            let sequencial = problem.sequence
            problemData.append((problem.sequence, problemString, isQuestion, problemColor))
            
            if problem.isOperator {
                if (index + 1) < problems.count {
                    let nextProblem = problems[index + 1]
                    let nextProblemString = nextProblem.isQuestion ? (viewModel.userAnswer.isEmpty ? "?" : viewModel.userAnswer) : nextProblem.problem
                    problemData.append((nextProblem.sequence, nextProblemString, nextProblem.isQuestion, nextProblem.color))
                    index += 1
                }
            }
            
            index += 1
        }
        
        return problemData
    }
    
    
}
