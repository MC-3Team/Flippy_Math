//
//  QuestionViewModel.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import RxSwift
import SwiftUI
import Network

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
    @Published var navigateToCredits = false
    @Published var showAlertInternet = false
    
    private let disposeBag = DisposeBag()
    var audioHelper = AudioHelper.shared
    
    var dynamicText: String {
        apretiation.isEmpty ? currentQuestionData.stories[currentMessageIndex].story : apretiation
    }
    private var isRecognitionInProgress = false
    @Published var readySoundAnalysis = false
    
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
        checkInternetConnection { [weak self] isConnected in
            guard isConnected else {
                self?.showAlertInternet = true
                return
            }
            
            guard let self = self else { return }
            self.readyStartRecognition = false
            self.speechRecognitionService.startRecognition()
                .do(onSubscribe: { [weak self] in
                    guard let self = self else { return }
                    print("Starting speech recognition...")
                    self.isProcessing = true
                    self.isFailed = false
                    self.isSuccess = (nil, false)
                })
                .subscribe(onNext: { [weak self] (text, success) in
                    self?.tipRecognition = false
                    self?.isSuccess = (text, success)
                    self?.userAnswer = text ?? ""
                    self?.isProcessing = false
                }, onError: { [weak self] error in
                    self?.isFailed = true
                    self?.isProcessing = false
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    func stopRecognition(tryRepeat: Bool) {
        guard !isRecognitionInProgress else { return }
        isRecognitionInProgress = true
        
        let group = DispatchGroup()
        group.enter()
        
        checkInternetConnection { [weak self] isConnected in
            guard isConnected else {
                self?.showAlertInternet = true
                group.leave()
                return
            }
            
            self?.speechRecognitionService.stopRecognition()
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
                .disposed(by: self?.disposeBag ?? DisposeBag())
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isRecognitionInProgress = false
            if tryRepeat {
                self?.readyStartRecognition = true
            }
        }
    }
    
    func startAnalysis() {
        readySoundAnalysis = false
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
        audioHelper.setSoundEffectVolume(0.1)
        audioHelper.playSoundEffect(named: "click", fileType: "wav")
        audioHelper.setSoundEffectVolume(1.0)
        
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
                readySoundAnalysis = true
                
            }
        }
        
        currentMessageIndex += 1
        riveInput = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
        
    }
    
    func checkTryAgainConnection() {
        checkInternetConnection { isConnected in
            if isConnected {
                self.showAlertInternet = false
                self.repeatQuestionHandling()
            } else {
                self.showAlertInternet = true
            }
        }
    }
    func checkInternetConnection(completion: @escaping (Bool) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    completion(true)
                } else {
                    completion(false)
                }
                monitor.cancel()
            }
        }
        
        monitor.start(queue: queue)
    }
    
    private func advanceMathIndex() {
        currentMathIndex += 1
    }
    
    private func advanceToNextQuestion() {
        if currentQuestionIndex == questionData.count - 1 {
            print(currentQuestionData)
            print(questionData.count-1)
            navigateToCredits = true
            currentQuestionIndex = questionData.count - 1
            currentMessageIndex = questionData[currentQuestionIndex].stories.count - 1
            currentMathIndex = 0
            userAnswer = ""
            audioHelper.stopVoice()
        } else {
            if !currentQuestionData.is_complete {
                let filteredQuestions = service.getAllQuestion().filter{ $0.sequence == currentQuestionData.sequence }
                service.updateCompletedQuestion(mathQuestion: filteredQuestions.first!, isComplete: true)
            }
            print(currentQuestionIndex)
            currentQuestionIndex += 1
            currentMessageIndex = 0
            currentMathIndex = 0
            userAnswer = ""
        }
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
    
    //    func randomPositionAroundCake(geometry: GeometryProxy, cakePosition: CGPoint) -> CGPoint {
    //        let offsetX = CGFloat.random(in: -800...300)
    //        let offsetY = CGFloat.random(in: -300...300)
    //        let xPosition = cakePosition.x + offsetX
    //        let yPosition = cakePosition.y + offsetY
    //
    //        return CGPoint(x: xPosition, y: yPosition)
    //    }
    
    /// MARK: SOAL NOMOR 5: Cakes & Flies
    @Published var flyPositions: [(x: CGFloat, y: CGFloat)] = []
    
    // Method to update fly positions based on the vertical size class
    func updateFlyPositions(for sizeClass: UserInterfaceSizeClass) {
        if sizeClass == .compact {
            flyPositions = [
                (x: 0.1, y: 0.6),
                (x: 0.16, y: 0.3),
                (x: 0.2, y: 0.7),
                (x: 0.3, y: 0.25),
                (x: 0.5, y: 0.45),
                (x: 0.45, y: 0.71),
                (x: 0.8, y: 0.7),
                (x: 0.75, y: 0.3),
                (x: 0.9, y: 0.5)
            ]
        } else {
            flyPositions = [
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
        }
    }
    
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
    @Published var babyFoxPositions: [(x: CGFloat, y: CGFloat)] = [
        (x: 0.456, y: 0.64),
        (x: 0.568, y: 0.66),
        (x: 0.202, y: 0.60),
        (x: 0.105, y: 0.64),
        (x: 0.78, y: 0.65),
        (x: 0.89, y: 0.6)
    ]
    
    func updateBabyFoxPositions(for sizeClass: UserInterfaceSizeClass) {
        if sizeClass == .compact {
            babyFoxPositions = [
                (x: 0.456, y: 0.64),
                (x: 0.568, y: 0.66),
                (x: 0.202, y: 0.60),
                (x: 0.105, y: 0.64),
                (x: 0.78, y: 0.65),
                (x: 0.89, y: 0.6)
            ]
        } else {
            babyFoxPositions = [
                (x: 0.476, y: 0.74),
                (x: 0.588, y: 0.76),
                (x: 0.222, y: 0.70),
                (x: 0.125, y: 0.74),
                (x: 0.8, y: 0.75),
                (x: 0.909, y: 0.7)
            ]
        }
    }
    
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
    func handleTap(tapThreshold: Int? = nil, tapDelay: Double = 0.5, upperLimit: Int = 2, isOutro : Bool) {
        isTapped = true
        
        if let threshold = tapThreshold {
            tapCount += 1
            if tapCount >= threshold {
                tapCount = 0
                if isOutro{
                    if currentMessageIndex < upperLimit {
                        self.checkAnswerAndAdvance()
                    }
                    
                } else{
                    moveToNextMessage(upperLimit: upperLimit)
                }
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + tapDelay) {
            self.isTapped = false
            if tapThreshold == nil {
                if isOutro{
                    if self.currentMessageIndex < upperLimit {
                        self.checkAnswerAndAdvance()
                    }
                    
                } else{
                    self.moveToNextMessage(upperLimit: upperLimit)
                }
                
            }
        }
    }
    
    private func moveToNextMessage(upperLimit: Int) {
        if currentMessageIndex < upperLimit {
            currentMessageIndex += 1
        }
    }
    
    
    
}
