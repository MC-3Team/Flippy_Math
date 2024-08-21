//
//  SoundAnalysisManager.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import CoreML
import SoundAnalysis
import AVFoundation
import RxSwift

class SoundAnalysisManager: NSObject, SoundAnalysisService {
    private var model: MLModel
    private var audioEngine: AVAudioEngine!
    private var streamAnalyzer: SNAudioStreamAnalyzer!
    private var request: SNClassifySoundRequest!
    
    private let subject = PublishSubject<(String?, Bool)>()
    
    override init() {
        guard let modelURL = Bundle.main.url(forResource: "ClappingModel", withExtension: "mlmodelc"),
              let loadedModel = try? MLModel(contentsOf: modelURL) else {
            fatalError("Failed to load the CoreML model.")
        }
        self.model = loadedModel
        super.init()
        self.setupAnalysis()
    }
    
    func setupAnalysis() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            fatalError("Failed to configure and activate audio session: \(error.localizedDescription)")
        }
    }
    
    func startAnalysis() -> Observable<(String?, Bool)> {

        audioEngine = AVAudioEngine()
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
        guard format.channelCount > 0 && format.sampleRate > 0 else {
            fatalError("Invalid audio format: channel count and sample rate must be nonzero")
        }
        
        streamAnalyzer = SNAudioStreamAnalyzer(format: format)
        request = try? SNClassifySoundRequest(mlModel: model)
        
        do {
            try audioEngine.start()
        } catch {
            fatalError("AudioEngine failed to start: \(error.localizedDescription)")
        }
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, when in
            self.streamAnalyzer.analyze(buffer, atAudioFramePosition: when.sampleTime)
        }
        
        do {
            try streamAnalyzer.add(request, withObserver: self)
        } catch {
            print("Failed to add request to stream analyzer: \(error.localizedDescription)")
        }
        
        return subject.asObservable()
    }
    
    func stopAnalysis() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}

extension SoundAnalysisManager: SNResultsObserving {
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else {
            return
        }
        
        for classification in result.classifications {
            _ = classification.identifier
            _ = classification.confidence
//            print("Detected \(identifier) with confidence: \(confidence * 100)%")
        }
        
        if let clapClassification = result.classifications.first(where: { $0.identifier == "Clap" && $0.confidence >= 0.9999 }) {
            DispatchQueue.main.async {
                self.subject.onNext((clapClassification.identifier, true))
                self.subject.onCompleted()
            }
        } else {
            DispatchQueue.main.async {
                self.subject.onNext(("No 100% Clap Detected", false))
            }
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Request failed: \(error.localizedDescription)")
        subject.onError(error)
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("Request complete.")
        subject.onCompleted()
    }
}
