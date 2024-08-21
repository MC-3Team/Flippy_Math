//
//  QuestionViewModel.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import RxSwift
import SwiftUI

class QuestionViewModel: ObservableObject {
    @Inject(name: "CoreDataManager") var service: DataService
    @Inject var speechRecognitionService: SpeechRecognizerService
    
    @Published var currentMessageIndex = 0
    @Published var currentMathIndex = 0
    @Published var currentQuestionIndex = 2
    @Published var userAnswer = ""
    @Published var apretiation = ""
    @Published var isProcessing: Bool = false
    @Published var isSuccess: (String?, Bool) = (nil, false)
    @Published var isFailed: Bool = false
    @Published var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    @Published var repeatQuestion: Bool = false
    
    private let disposeBag = DisposeBag()
    var audioHelper = AudioHelper.shared
    
    var dynamicText: String {
        apretiation.isEmpty ? currentQuestionData.stories[currentMessageIndex].story : apretiation
    }
    
    var questionData: [QuestionData] = []
    
    // Modify to accept level parameter
    init(level: Int) {
        self.currentQuestionIndex = level
        getInCompleteQuestion()
        audioHelper.playMusic(named: "birthday-party", fileType: "wav")
    }
    
    func clearNavigation() {
        currentMessageIndex = 0
        currentMathIndex = 0
        currentQuestionIndex = 2
        userAnswer = ""
        apretiation = ""
        isProcessing = false
        isSuccess = (nil, false)
        isFailed = false
        riveInput = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
        repeatQuestion = false
    }
    
    func getInCompleteQuestion() {
        questionData = service.getInCompleteQuestion()
            .map { question in
                let storiesArray = (question.stories as? Set<Story>)?
                    .sorted { $0.sequence < $1.sequence }
                    .map { story in
                        StoryData(
                            id: Int(story.sequence),
                            sequence: Int(story.sequence),
                            story: story.story ?? "",
                            audio: story.audio ?? "",
                            appretiation: story.apretiation ?? "",
                            audio_apretiation: story.audio_apretiation ?? ""
                        )
                    } ?? []
                
                let problemsArray = (question.problems as? Set<Problem>)?
                    .sorted { $0.sequence < $1.sequence }
                    .map { problem in
                        ProblemData(
                            id: Int(problem.sequence),
                            sequence: Int(problem.sequence),
                            color: problem.color ?? "",
                            problem: problem.problem ?? "",
                            isOperator: problem.is_operator,
                            isQuestion: problem.is_question,
                            isSpeech: problem.is_speech
                        )
                    } ?? []
                
                return QuestionData(
                    id: Int(question.sequence),
                    sequence: Int(question.sequence),
                    background: question.background ?? "",
                    is_complete: question.is_complete,
                    stories: storiesArray,
                    problems: problemsArray
                )
            }
    }
    
    var currentQuestionData: QuestionData {
        questionData[currentQuestionIndex]
    }
    
    func advanceMessageAndMath() {
        let totalProblems = currentQuestionData.problems.count
        let totalMessages = currentQuestionData.stories.count
        
        if currentMessageIndex < totalMessages - 1 {
            currentMessageIndex += 1
            if currentMathIndex < totalProblems - 1 {
                currentMathIndex += 1
                if currentQuestionData.problems[currentMathIndex].isOperator {
                    currentMathIndex += 1
                }
            } else {
                currentMathIndex = totalProblems - 1
            }
        } else if currentMathIndex < totalProblems - 1 {
            currentMathIndex += 1
        } else if currentQuestionIndex < questionData.count - 1 {
            currentQuestionIndex += 1
            currentMessageIndex = 0
            currentMathIndex = 0
        } else {
            print("Something here")
        }
    }
    
    func startRecognition() {
        speechRecognitionService.startRecognition()
            .do(onSubscribe: { [weak self] in
                print("Starting speech recognition...")
                self?.isProcessing = true
                self?.isFailed = false
                self?.isSuccess = (nil, false)
            })
            .subscribe(onNext: { [self] (text, success) in
                self.isSuccess = (text, success)
                self.userAnswer = text ?? ""
                self.isProcessing = false
            }, onError: { [weak self] error in
                self?.isFailed = true
                self?.isProcessing = false
            })
            .disposed(by: disposeBag)
    }
    
    func stopRecognition() {
        speechRecognitionService.stopRecognition()
        isProcessing = false
        isSuccess = (nil, false)
        isFailed = false
    }
    
    func checkAnswerAndAdvance() {
        if currentMathIndex < currentQuestionData.problems.count {
            let currentProblem = currentQuestionData.problems[currentMathIndex]
            if !apretiation.isEmpty {
                apretiation = ""
                userAnswer = ""
                currentMathIndex += 1
                if currentMathIndex < currentQuestionData.problems.count {
                    if currentQuestionData.problems[currentMathIndex].isOperator {
                        currentMathIndex += 1
                    }
                    
                    if currentQuestionData.problems[currentMathIndex].isQuestion {
                        startRecognition()
                    }
                    currentMessageIndex += 1
                    riveInput = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
                } else {
                    currentQuestionIndex += 1
                    currentMessageIndex = 0
                    currentMathIndex = 0
                    userAnswer = ""
                }
            }
            else if currentProblem.isQuestion && apretiation.isEmpty {
                if userAnswer == currentProblem.problem {
                    stopRecognition()
                    audioHelper.playSoundEffect(named: "correct", fileType: "wav")
                    apretiation = currentQuestionData.stories[currentMessageIndex].appretiation
                    riveInput = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0)),
                                 FlippyRiveInput(key: .isRightHandsUp, value: .bool(true))
                    ]
                } else {
                    stopRecognition()
                    userAnswer = ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        self?.startRecognition()
                    }
                    audioHelper.playSoundEffect(named: "failure-drum", fileType: "wav")
                    riveInput = [
                        FlippyRiveInput(key: .isSad, value: .bool(true))]
                    let options = ["hmmm", "oops"]
                    audioHelper.playVoiceOver(named: options.randomElement() ?? "hmmm", fileType: "wav")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                        self?.riveInput = [
                            FlippyRiveInput(key: .isSad, value: .bool(false))
                        ]
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self?.riveInput = [
                                FlippyRiveInput(key: .talking, value: .float(0.0))
                            ]
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self?.riveInput = [
                                    FlippyRiveInput(key: .talking, value: .float(2.0))
                                ]
                                self?.repeatQuestion = !(self?.repeatQuestion ?? false)
                            }
                        }
                    }
                }
            } else {
                currentMathIndex += 1
                if currentQuestionData.problems[currentMathIndex].isOperator {
                    currentMathIndex += 1
                }
                if currentQuestionData.problems[currentMathIndex].isQuestion {
                    if currentQuestionData.problems[currentMathIndex].isSpeech {
                        startRecognition()
                    } else {
                        
                    }
                    
                }
                currentMessageIndex += 1
                riveInput = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
            }
        } else {
            currentQuestionIndex += 1
            currentMessageIndex = 0
            currentMathIndex = 0
            userAnswer = ""
        }
    }
    
    
    /// MARK: SOAL NOMOR 5: Cakes & Flies
    var flyPositions: [(x: CGFloat, y: CGFloat)] = [
        (x: 0.1, y: 0.7),
        (x: 0.16, y: 0.4),
        (x: 0.2, y: 0.8),
        (x: 0.3, y: 0.35),
        (x: 0.5, y: 0.55),
        (x: 0.45, y: 0.81),
        (x: 0.8, y: 0.8),
        (x: 0.75, y: 0.4),
        (x: 0.9, y: 0.6)
    ]
    
    var flyCount: Int {
        return (currentMessageIndex >= 4) ? 2 : flyPositions.count
    }
    
    func flyPosition(for index: Int, geometry: GeometryProxy) -> (x: CGFloat, y: CGFloat) {
        let position = flyPositions[index]
        return (x: geometry.size.width * position.x, y: geometry.size.height * position.y)
    }
    
    func flyAnimation(for index: Int, geometry: GeometryProxy) {
        let startPosition = flyPositions[index]
        let animation = Animation.easeInOut(duration: Double.random(in: 2...5))
            .repeatForever(autoreverses: true)
        
        withAnimation(animation) {
            flyPositions[index] = (
                x: startPosition.x + CGFloat.random(in: -0.1...0.1),
                y: startPosition.y + CGFloat.random(in: -0.1...0.1)
            )
        }
    }
    
    /// MARK: SOAL NOMOR 6: Arctic Fox
    @Published var isPlaying: Bool = false
    let babyFoxPositions: [(x: CGFloat, y: CGFloat)] = [
        (x: 0.476, y: 0.74),
        (x: 0.588, y: 0.76),
        (x: 0.222, y: 0.70),
        (x: 0.125, y: 0.74),
        (x: 0.8, y: 0.75),
        (x: 0.909, y: 0.7)
    ]
    
    var foxCount: Int {
        return (currentMessageIndex < 3) ? 2 : babyFoxPositions.count
    }
    
    func babyFoxPosition(for index: Int, geometry: GeometryProxy) -> (x: CGFloat, y: CGFloat) {
        let position = babyFoxPositions[index]
        return (x: geometry.size.width * position.x, y: geometry.size.height * position.y)
    }
    
    /// MARK: SOAL NOMOR 7: PINATA
    @Published var tapCount = 0
    @Published var isTapped = false
    
    /// MARK: SOAL NOMOR 9: Outro
    @Published var rotation: Double = 0
    @Published var scale: CGFloat = 0.5
    
    
    ///MARK: SHARED
    func handleTap(tapThreshold: Int? = nil, tapDelay: Double = 0.5) {
        isTapped = true
        
        if let threshold = tapThreshold {
            tapCount += 1
            if tapCount >= threshold {
                tapCount = 0
                moveToNextMessage(upperLimit: 2)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + tapDelay) {
            self.isTapped = false
            if tapThreshold == nil {
                self.moveToNextMessage(upperLimit: 2)
            }
        }
    }
    
    private func moveToNextMessage(upperLimit: Int) {
        if currentMessageIndex < upperLimit {
            currentMessageIndex += 1
        }
    }
}
