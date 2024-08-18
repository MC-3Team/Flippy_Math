//
//  HomeViewModel.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import RxSwift
import Speech

class HomeViewModel: ObservableObject {
    @Inject(name: "CoreDataManager") var service: DataService
    @Inject private var speechRecognitionService: SpeechRecognizerService
    @Inject private var soundAnalysisService: SoundAnalysisService
    
    @Published var isProcessing: Bool = false
    @Published var isSuccess: (String?, Bool) = (nil, false)
    @Published var isFailed: Bool = false
    @Published var clapCount: Int = 0
    @Published var snowflakes: [Snowflake] = []
    @Published var animate = false
    @Published var isMusicOn = true
    
    private let numberOfSnowflakes = 75
    private let disposeBag = DisposeBag()
    
    func startRecognition() {
        speechRecognitionService.startRecognition()
            .do(onSubscribe: { [weak self] in
                print("Starting speech recognition...")
                self?.isProcessing = true
                self?.isFailed = false
                self?.isSuccess = (nil, false)
            })
            .subscribe(onNext: { [weak self] (text, success) in
                self?.isSuccess = (text, success)
                //                self?.isProcessing = false
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
                if success, label == "Clap" {
                    self?.clapCount += 1
                }
                //                self?.isProcessing = false
            }, onError: { [weak self] error in
                self?.isFailed = true
                self?.isProcessing = false
            })
            .disposed(by: disposeBag)
    }
    
    func stopAnalysis() {
        soundAnalysisService.stopAnalysis()
        isProcessing = false
        isSuccess = (nil, false)
        isFailed = false
    }
    
    func createSnowflakes(in size: CGSize) {
        snowflakes.removeAll()
        for _ in 0..<numberOfSnowflakes {
            let xPosition = CGFloat.random(in: 0...size.width)
            let duration = Double.random(in: 5...15)
            let delay = Double.random(in: 0...20)
            let snowflakeSize = CGFloat.random(in: 10...30)
            let imageName = Bool.random() ? "snow1" : "snow2" // Replace with your snowflake asset names
            let rotationDuration = Double.random(in: 3...10)
            let snowflake = Snowflake(xPosition: xPosition, duration: duration, delay: delay, size: snowflakeSize, imageName: imageName, rotationDuration: rotationDuration)
            snowflakes.append(snowflake)
        }
    }
    
//    func testingData() {
//        service.insertAllData()
//        print(service.getInCompleteQuestion().count)
//    }
}
