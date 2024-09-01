//
//  QuestionLayout.swift
//  FlippyMath
//
//  Created by Rajesh Triadi Noftarizal on 13/08/24.
//

import SwiftUI
import RiveRuntime
import Routing

struct QuestionLayout<Content: View>: View {
    @ObservedObject var viewModel: QuestionViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var router: Router<NavigationRoute>
    
    let children: (GeometryProxy) -> Content
    @State private var textPositions: [Int: CGPoint] = [:]
    
    init(viewModel: QuestionViewModel, @ViewBuilder children: @escaping (GeometryProxy) -> Content) {
        self.viewModel = viewModel
        self.children = children
    }
    @StateObject var riveVM = RiveViewModel(fileName: "clap", autoPlay: true)
    
    @State private var currentImage: String = ""
    
    ///iPhone UI
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var isCompact: Bool {
        verticalSizeClass == .compact
    }
    let backgroundScale: CGFloat = 1.2
    
    @State var backgroundImageName = "Q1_iPhoneBackground"
    
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                if isCompact {
                    
                    Image(backgroundImageName)
                        .resizable()
                        .frame(
                            width: geometry.size.width * backgroundScale,
                            height: geometry.size.height * backgroundScale
                        )
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
                        .onAppear(){
                            switch viewModel.currentQuestionIndex {
                            case 0 :
                                backgroundImageName = "Q0_iPhoneBackground"
                            case 1 :
                                backgroundImageName = "Q1_iPhoneBackground"
                            case 2 :
                                backgroundImageName = "Q2_iPhoneBackground"
                            case 3 :
                                backgroundImageName = "Q3_iPhoneBackground"
                            case 4 :
                                backgroundImageName = "Q3_iPhoneBackground"
                            case 5 :
                                backgroundImageName = "Q4_iPhoneBackground"
                            case 6 :
                                backgroundImageName = "Q5_iPhoneBackground"
                            case 7 :
                                backgroundImageName = "Q6_iPhoneBackground"
                            case 8 :
                                backgroundImageName = "Q7_iPhoneBackground"
                            case 9 :
                                backgroundImageName = "Q8_iPhoneBackground"
                            case 10 :
                                backgroundImageName = "Q9_iPhoneBackground"
                            default:
                                backgroundImageName = "Q0_iPhoneBackground"
                            }
                        }
                        .onChange(of: viewModel.currentQuestionIndex){
                            switch viewModel.currentQuestionIndex {
                            case 0 :
                                backgroundImageName = "Q0_iPhoneBackground"
                            case 1 :
                                backgroundImageName = "Q1_iPhoneBackground"
                            case 2 :
                                backgroundImageName = "Q2_iPhoneBackground"
                            case 3 :
                                backgroundImageName = "Q3_iPhoneBackground"
                            case 4 :
                                backgroundImageName = "Q3_iPhoneBackground"
                            case 5 :
                                backgroundImageName = "Q4_iPhoneBackground"
                            case 6 :
                                backgroundImageName = "Q5_iPhoneBackground"
                            case 7 :
                                backgroundImageName = "Q6_iPhoneBackground"
                            case 8 :
                                backgroundImageName = "Q7_iPhoneBackground"
                            case 9 :
                                backgroundImageName = "Q8_iPhoneBackground"
                            case 10 :
                                backgroundImageName = "Q9_iPhoneBackground"
                            default:
                                backgroundImageName = "Q0_iPhoneBackground"
                            }
                        }
                } else {
                    Image(viewModel.currentQuestionData.background)
                        .resizable()
                        .frame(
                            width: geometry.size.width * 1.2,
                            height: geometry.size.height * 1.2
                        )
                        .position(
                            x: geometry.size.width / 2,
                            y: geometry.size.height / 2
                        )
                    // .scaledToFill()
                    // .ignoresSafeArea()
                }
                
                if isCompact {
                    Button {
                        router.navigateToRoot()
                    } label: {
                        Image("HomeButton")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
             
                    }
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                    .position(x: geometry.size.width * 0.01, y: geometry.size.height * 0.1)
                } else {
                    Button {
                        print("asdads")
                        router.navigateToRoot()
                    } label: {
                        Image("HomeButton")
                            .resizable()
                          
                    }
                    .frame(width: geometry.size.width * 0.11, height: geometry.size.height * 0.15)
                    .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.08)
                }
                
                
                children(geometry)
                
                if isCompact {
                    HStack {
                        ForEach(getMathProblems(), id: \.0) { (sequence, problemString, isQuestion, problemColor) in
                            ZStack(alignment: .topLeading) {
                                VStack(spacing: 0) {
                                    let isCurrentQuestion = isQuestion && viewModel.userAnswer.isEmpty
                                    
                                    Text(problemString)
                                        .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
                                        .fontWeight(.heavy)
                                        .foregroundColor(Color(problemColor))
                                        .multilineTextAlignment(.center)
                                        .padding(.top, 16)
                                    //                                        .padding(.horizontal, 16)
                                        .padding(.bottom, isCurrentQuestion ? 0 : 16)
                                        .background(
                                            GeometryReader { geo in
                                                Color.clear.onAppear {
                                                    if isCurrentQuestion {
                                                        textPositions.removeAll()
                                                        let globalPosition = geo.frame(in: .global).origin
                                                        DispatchQueue.main.async {
                                                            textPositions[sequence] = globalPosition
                                                        }
                                                    }
                                                }
                                            }
                                                .frame(width: 0, height: 0)
                                        )
                               
                                    
                                    if isCurrentQuestion {
                                        Spacer().frame(height: 16)
                                    }
                                }
                                
                            }
                        }.id(viewModel.repeatProblem)
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)
                } else {
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
                                                        textPositions.removeAll()

                                                        let globalPosition = geo.frame(in: .global).origin
                                                        DispatchQueue.main.async {
                                                            textPositions[sequence] = globalPosition
                                                        }
                                                    }
                                                }
                                            }
                                                .frame(width: 0, height: 0)
                                        )
                                 
                                    if isCurrentQuestion {
                                        Spacer().frame(height: 16)
                                    }
                                }
                                
                            }
                        }.id(viewModel.repeatProblem)
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.25)
                }
                
                
                ForEach(Array(textPositions.keys.sorted()), id: \.self) { key in
                    if let position = textPositions[key], viewModel.tipRecognition == true {
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
                        .position(x: position.x - 8 , y: position.y + 96)
                    }
                }
                
                if isCompact {
                    HStack {
                        FlippyRiveView(riveInput: $viewModel.riveInput)
                            .frame(width: geometry.size.width * 0.25)
                            .position(x: geometry.size.width * 0.02, y: geometry.size.height * 0.92)
                        
                        ZStack(alignment: .leading) {
                            Image("MessagePlaceholder")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.25)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                            
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
                                if viewModel.readyStartRecognition {
                                    viewModel.startRecognition()
                                    viewModel.tipRecognition = true
                                }
                                
                                if viewModel.readySoundAnalysis {
                                    viewModel.startAnalysis()
                                    viewModel.tipRecognition = true
                                }
                            }).id(viewModel.repeatQuestion)
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                .lineLimit(2)
                                .minimumScaleFactor(0.6)
                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                            
                            if viewModel.currentQuestionIndex == 6 && viewModel.currentMessageIndex == 3 && viewModel.userAnswer.isEmpty {
                                HStack {
                                    Spacer()
                                    riveVM.view().frame(width: 120, height: 120).padding(.trailing, 20).padding(.bottom, 10)
                                }
                            }
                        }
                        
                        Button(action: {
                            viewModel.checkAnswerAndAdvance()
                        }, label: {
                            Image(determineButtonImage())
                                .resizable()
                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                        })
                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.97)
                        .disabled(
                            (viewModel.currentQuestionData.problems != [] ? viewModel.currentQuestionData.problems[viewModel.currentMathIndex].isQuestion && viewModel.userAnswer.isEmpty : false)
                            || viewModel.currentQuestionIndex == 8 && viewModel.currentMessageIndex == 1 ? true : false
                            || viewModel.currentQuestionIndex == 4 && viewModel.currentMessageIndex == 1 ? true : false
                            || viewModel.currentQuestionIndex == 10 && viewModel.currentMessageIndex == 2 ? true : false
                            
                        )
                    }
                    .onDisappear {
                        textPositions.removeAll()
                    }
                } else {
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
                                if viewModel.readyStartRecognition {
                                    viewModel.startRecognition()
                                    viewModel.tipRecognition = true
                                }
                                
                                if viewModel.readySoundAnalysis {
                                    viewModel.startAnalysis()
                                    viewModel.tipRecognition = true
                                }
                            }).id(viewModel.repeatQuestion)
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 34))
                                .fontWeight(.bold)
                                .padding(.leading, 80)
                                .padding(.trailing, viewModel.currentQuestionIndex == 5 && viewModel.currentMessageIndex == 3 ? 100 : 10)
                                .padding(.bottom, 10)
                                .lineLimit(nil)
                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            
                            if viewModel.currentQuestionIndex == 6 && viewModel.currentMessageIndex == 3 && viewModel.userAnswer.isEmpty {
                                HStack {
                                    Spacer()
                                    riveVM.view().frame(width: 120, height: 120).padding(.trailing, 20).padding(.bottom, 10)
                                }
                            }
                        }
                        .position(x: geometry.size.width * 0.14, y: geometry.size.height * 0.94)
                        
                        Button(action: {
                            viewModel.checkAnswerAndAdvance()
                        }, label: {
                            Image(determineButtonImage())
                                .resizable()
                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                        })
                        .position(x: geometry.size.width * 0.23, y: geometry.size.height * 0.955)
                        .disabled(
                            (viewModel.currentQuestionData.problems != [] ? viewModel.currentQuestionData.problems[viewModel.currentMathIndex].isQuestion && viewModel.userAnswer.isEmpty : false)
                            || viewModel.currentQuestionIndex == 8 && viewModel.currentMessageIndex == 1 ? true : false
                            || viewModel.currentQuestionIndex == 4 && viewModel.currentMessageIndex == 1 ? true : false
                            || viewModel.currentQuestionIndex == 10 && viewModel.currentMessageIndex == 2 ? true : false
                        )
                    }
                    .onDisappear {
                        textPositions.removeAll()
                    }
                }
            }
        }.onAppear {
            currentImage = viewModel.currentQuestionData.background
            viewModel.audioHelper.playMusicQuestion(named: "birthday-party", fileType: "mp3")
        }
        .customAlert(isPresented: $viewModel.showAlertInternet) {
            CustomAlertView(primaryButtonTitle: "Coba Lagi", primaryButtonAction: {
                viewModel.checkTryAgainConnection()
            }, secondaryButtonTitle: "Beranda", secondaryButtonAction: {
                router.navigateToRoot()
            })
        }
        .onChange(of: viewModel.currentQuestionData) {_, _ in
            currentImage = viewModel.currentQuestionData.background
        }
        .onChange(of: viewModel.navigateToCredits) { _ , _ in
            if viewModel.navigateToCredits {
                router.navigate(to: .credit)
                viewModel.navigateToCredits = false
            }
        }
        .onDisappear {
            currentImage = ""
            viewModel.audioHelper.stopVoice()
            viewModel.audioHelper.stopMusicQuestion()
        }
    }
    
    func determineButtonImage() -> String {
        if !viewModel.apretiation.isEmpty {
            return "NextButton"
        } else if viewModel.currentQuestionIndex == 4 && viewModel.currentMessageIndex == 1{
            return "NextButtonDisable"
        } else if viewModel.currentQuestionIndex == 8 && viewModel.currentMessageIndex == 1 {
            return "NextButtonDisable"
        } else if  viewModel.currentQuestionIndex == 10 && viewModel.currentMessageIndex == 2{
            return "NextButtonDisable"
        } else if !viewModel.currentQuestionData.problems.isEmpty {
            let currentProblem = viewModel.currentQuestionData.problems[viewModel.currentMathIndex]
            if currentProblem.isQuestion {
                return viewModel.userAnswer.isEmpty ? "CorrectButtonGray" : "CorrectButton"
            } else {
                return "NextButton"
            }
        } else {
            return "NextButton"
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
