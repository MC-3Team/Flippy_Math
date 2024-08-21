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

class SoundAnalysisManager: NSObject, SoundAnalysisService, SNResultsObserving {
    private var model: MLModel
    private var audioEngine: AVAudioEngine!
    private var streamAnalyzer: SNAudioStreamAnalyzer!
    private var request: SNClassifySoundRequest!

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
        let subject = PublishSubject<(String?, Bool)>()
        audioEngine = AVAudioEngine()
        
        let inputNode = audioEngine.inputNode
        let format = inputNode.inputFormat(forBus: 0)
        
        guard format.channelCount > 0 && format.sampleRate > 0 else {
            fatalError("Invalid audio format: channel count and sample rate must be nonzero")
        }
        
        streamAnalyzer = SNAudioStreamAnalyzer(format: format)
        
        do {
            request = try SNClassifySoundRequest(mlModel: model)
        } catch {
            fatalError("Failed to create SNClassifySoundRequest: \(error.localizedDescription)")
        }
        
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
            fatalError("Failed to add request to stream analyzer: \(error.localizedDescription)")
        }

        // Hubungkan subject ke dalam SNResultsObserving menggunakan properti tertutup (closure)
        self.resultHandler = { identifier, success in
            print(identifier)
            subject.onNext((identifier, success))
            if success {
                subject.onCompleted()
            }
        }
        
        return subject.asObservable()
    }
    
    func stopAnalysis() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    // Menggunakan closure untuk menyimpan hasil observasi
    private var resultHandler: ((String?, Bool) -> Void)?
    
    // Conformance to SNResultsObserving protocol
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else {
            return
        }
        
        if let clapClassification = result.classifications.first(where: { $0.identifier == "Clap" && $0.confidence >= 0.9999 }) {
            DispatchQueue.main.async {
                self.resultHandler?(clapClassification.identifier, true)
            }
        } else {
            DispatchQueue.main.async {
                self.resultHandler?("No 100% Clap Detected", false)
            }
        }
    }
    
    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Request failed: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.resultHandler?(nil, false)
        }
    }
    
    func requestDidComplete(_ request: SNRequest) {
        print("Request complete.")
    }
}
