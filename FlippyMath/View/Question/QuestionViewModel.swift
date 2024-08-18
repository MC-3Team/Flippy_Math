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
    
    // Random Position for Flies
    func randomPositionAroundCake(geometry: GeometryProxy, cakePosition: CGPoint) -> CGPoint {
        let offsetX = CGFloat.random(in: -800...300)
        let offsetY = CGFloat.random(in: -300...300)
        let xPosition = cakePosition.x + offsetX
        let yPosition = cakePosition.y + offsetY
        
        return CGPoint(x: xPosition, y: yPosition)
    }
}
