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
    @Inject private var soundAnalysisService: SoundAnalysisService
    
    @Published var repeatProblem: Int = 0
    @Published var currentMessageIndex = 0
    @Published var currentMathIndex = 0
    @Published var currentQuestionIndex = 0
    @Published var userAnswer = ""
    @Published var apretiation = ""
    @Published var isProcessing: Bool = false
    @Published var isSuccess: (String?, Bool) = (nil, false)
    @Published var isFailed: Bool = false
    @Published var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    @Published var repeatQuestion: Bool = false
    @Published var parameter: Parameter = .home
    @Published var readyStartRecognition = false
    @Published var tipRecognition = false
    
    private let disposeBag = DisposeBag()
    var audioHelper = AudioHelper.shared
    
    var dynamicText: String {
        apretiation.isEmpty ? currentQuestionData.stories[currentMessageIndex].story : apretiation
    }
    private var isRecognitionInProgress = false
    
    var questionData: [QuestionData] = []
    
    init(sequenceLevel: Int, parameter: Parameter) {
        switch parameter {
        case .history:
//            currentQuestionIndex = Int(mathQuestion.sequence)
           getAllQuestion()
            currentQuestionIndex = sequenceLevel
            
        case .home :
            getAllQuestion()
            currentQuestionIndex = sequenceLevel
        default :
            getInCompleteQuestion()
        }
    }
    
    func clearNavigation() {
        currentMessageIndex = 0
        currentMathIndex = 0
        currentQuestionIndex = 0
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
    
    func getAllQuestion() {
        questionData = service.getAllQuestion()
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
    
    func startRecognition() {
        readyStartRecognition = false
        speechRecognitionService.startRecognition()
            .do(onSubscribe: { [weak self] in
                guard let self = self else { return }
                print("Starting speech recognition...")
                self.isProcessing = true
                self.isFailed = false
                self.isSuccess = (nil, false)
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
    
    func stopRecognition(tryRepeat : Bool) {
        guard !isRecognitionInProgress else { return }
        isRecognitionInProgress = true
        
        let group = DispatchGroup()
        group.enter()
        
        speechRecognitionService.stopRecognition()
            .do(onSubscribe: { [weak self] in
                print("Stop speech recognition...")
                self?.isProcessing = true
                self?.isFailed = false
                self?.isSuccess = (nil, false)
            })
            .subscribe(onNext: { [weak self] success in
                self?.isProcessing = false
                self?.isSuccess = (nil, false)
                self?.isFailed = false
            }, onError: { [weak self] error in
                self?.isFailed = true
                self?.isProcessing = false
            }, onCompleted: {
                group.leave()
            })
            .disposed(by: disposeBag)
        
        group.notify(queue: .main) {
            self.isRecognitionInProgress = false
            if tryRepeat {
                self.readyStartRecognition = true
            }
        }
    }
    
    func startAnalysis() {
        soundAnalysisService.startAnalysis()
            .do(onSubscribe: { [weak self] in
                print("Starting sound analysis...")
                self?.isProcessing = true
                self?.isFailed = false
                self?.isSuccess = (nil, false)
            })
            .subscribe(onNext: { [weak self] (label, success) in
                self?.isSuccess = (label, success)
                self?.isFailed = false
                self?.isProcessing = false
            }, onError: { [weak self] error in
                self?.isFailed = true
                self?.isProcessing = false
            }, onCompleted: {
                self.stopAnalysis()
                self.userAnswer =  self.currentQuestionData.problems[self.currentMathIndex].problem
                self.audioHelper.playSoundEffect(named: "correct", fileType: "wav")
                self.apretiation = self.currentQuestionData.stories[self.currentMessageIndex].appretiation
                self.riveInput = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0)),
                                   FlippyRiveInput(key: .isRightHandsUp, value: .bool(true))
                ]
                
            })
            .disposed(by: disposeBag)
    }
    
    func stopAnalysis() {
        soundAnalysisService.stopAnalysis()
        isProcessing = false
        isSuccess = (nil, false)
        isFailed = false
    }
    
    func checkAnswerAndAdvance() {
        if currentQuestionIndex >= questionData.count - 1 {
                let sequence = currentQuestionData.sequence
                if let mathQuestion = service.getMathQuestion(by: sequence) {
                    service.updateCompletedQuestion(mathQuestion: mathQuestion, isComplete: true)
                }
            }
        
        audioHelper.playSoundEffect(named: "click", fileType: "wav")
        guard !currentQuestionData.problems.isEmpty else {
            advanceToNextStory()
            return
        }
        
        guard currentMathIndex < currentQuestionData.problems.count else {
            advanceToNextQuestion()
            return
        }
        
        let currentProblem = currentQuestionData.problems[currentMathIndex]
        
        if !apretiation.isEmpty {
            resetForNextProblem()
            processNextProblem()
            return
        }
        
        if currentProblem.isQuestion {
            handleQuestionProblem(currentProblem)
        } else {
            advanceMathIndex()
            processNextProblem()
        }
    }
    
    private func handleQuestionProblem(_ problem: ProblemData) {
        tipRecognition = false
        if userAnswer == problem.problem {
            handleCorrectAnswer()
        } else {
            handleIncorrectAnswer()
        }
    }
    
    private func handleCorrectAnswer() {
        stopRecognition(tryRepeat: false)
        audioHelper.playSoundEffect(named: "correct", fileType: "wav")
        apretiation = currentQuestionData.stories[currentMessageIndex].appretiation
        riveInput = [
            FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0)),
            FlippyRiveInput(key: .isRightHandsUp, value: .bool(true))
        ]
    }
    
    private func handleIncorrectAnswer() {
        stopRecognition(tryRepeat: true)
        userAnswer = ""
        audioHelper.playSoundEffect(named: "failure-drum", fileType: "wav")
        riveInput = [
            FlippyRiveInput(key: .isSad, value: .bool(true))
        ]
        let options = ["hmmm", "oops"]
        audioHelper.playVoiceOver(named: options.randomElement() ?? "hmmm", fileType: "wav")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.riveInput = [
                FlippyRiveInput(key: .isSad, value: .bool(false))
            ]
            self?.repeatQuestionHandling()
        }
    }
    
    private func repeatQuestionHandling() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.riveInput = [
                FlippyRiveInput(key: .talking, value: .float(0.0))
            ]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.riveInput = [
                    FlippyRiveInput(key: .talking, value: .float(2.0))
                ]
                self.repeatQuestion.toggle()
            }
        }
    }
    
    private func resetForNextProblem() {
        apretiation = ""
        userAnswer = ""
        currentMathIndex += 1
    }
    
    private func processNextProblem() {
        guard currentMathIndex < currentQuestionData.problems.count else {
            advanceToNextQuestion()
            return
        }
        
        let nextProblem = currentQuestionData.problems[currentMathIndex]
        
        if nextProblem.isOperator {
            currentMathIndex += 1
            processNextProblem()
            return
        }
        
        if nextProblem.isQuestion {
            if nextProblem.isSpeech {
                readyStartRecognition = true
            } else {
                startAnalysis()
            }
        }
        
        currentMessageIndex += 1
        riveInput = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    }
    
    private func advanceMathIndex() {
        currentMathIndex += 1
    }
    
    private func advanceToNextQuestion() {
        if !currentQuestionData.is_complete {
            let filteredQuestions = service.getAllQuestion().filter{ $0.sequence == currentQuestionData.sequence }
            service.updateCompletedQuestion(mathQuestion: filteredQuestions.first!, isComplete: true)
        }
        currentQuestionIndex += 1
        currentMessageIndex = 0
        currentMathIndex = 0
        userAnswer = ""
    }
    
    private func advanceToNextStory() {
        guard currentMathIndex < currentQuestionData.stories.count - 1 else {
            advanceToNextQuestion()
            return
        }
        
        currentMathIndex += 1
        currentMessageIndex += 1
        riveInput = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    }
    
    func randomPositionAroundCake(geometry: GeometryProxy, cakePosition: CGPoint) -> CGPoint {
        let offsetX = CGFloat.random(in: -800...300)
        let offsetY = CGFloat.random(in: -300...300)
        let xPosition = cakePosition.x + offsetX
        let yPosition = cakePosition.y + offsetY
        
        return CGPoint(x: xPosition, y: yPosition)
    }
}
