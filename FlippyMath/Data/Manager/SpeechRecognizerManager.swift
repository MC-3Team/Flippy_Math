//
//  SpeechRecognizerManager.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import Speech
import AVFoundation
import RxSwift

class SpeechRecognitionManager: NSObject, SpeechRecognizerService, SFSpeechRecognizerDelegate {
    
    private var audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "id_ID"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var isStopped = false
    private let silenceDetectionTimeout: TimeInterval = 5.0
    private let restartSubject = PublishSubject<Void>()
    private var disposeBag = DisposeBag()
    private var silenceTimer: Timer? // Menambahkan deklarasi silenceTimer
    
    override init() {
        super.init()
        setupRecognition()
    }
    
    func setupRecognition() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.duckOthers, .allowBluetooth, .defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Couldn't configure the audio session properly")
        }
    }
    
    func startRecognition() -> Observable<(String?, Bool)> {
        let subject = PublishSubject<(String?, Bool)>()
        
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        isStopped = false
        
        let inputNode = audioEngine.inputNode
        
        guard let speechRecognizer = speechRecognizer else {
            assertionFailure("Speech recognizer is not initialized!")
            subject.onCompleted()
            return subject
        }
        
        guard speechRecognizer.isAvailable else {
            assertionFailure("Speech recognizer is not available!")
            subject.onCompleted()
            return subject
        }
        
        guard let recognitionRequest = recognitionRequest else {
            assertionFailure("Unable to create recognition request!")
            subject.onCompleted()
            return subject
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        speechRecognizer.delegate = self
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            recognitionRequest.append(buffer)
        }
        
        recognitionTask = createRecognitionTask(subject: subject)
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Couldn't start audio engine!")
            subject.onError(error)
        }
        
        return subject
    }
    
    func stopRecognition() -> Observable<Bool> {
        let subject = PublishSubject<Bool>()
        isStopped = true
        recognitionTask?.finish()
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        audioEngine.stop()
        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        silenceTimer?.invalidate() // Menonaktifkan silenceTimer saat berhenti
        subject.onCompleted()
        return subject
    }
    
    private func createRecognitionTask(subject: PublishSubject<(String?, Bool)>) -> SFSpeechRecognitionTask {
        return speechRecognizer!.recognitionTask(with: recognitionRequest!) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error in recognition task: \(error.localizedDescription)")
                self.handleError(error, subject: subject)
                self.restartSubject.onNext(()) // Trigger restart on error
                subject.onCompleted()
                return
            }
            
            if let result = result {
                let transcription = result.bestTranscription.formattedString.lowercased()

                let wordToNumberMap: [String: String] = ["nol": "0", "enol" : "0", "kosong" : "0",
                                                         "satu": "1", "dua": "2", "tiga": "3", "empat": "4", "lima": "5", "nam" : "6",
                                                         "enam": "6", "tujuh": "7", "delapan": "8", "sembilan": "9"]

                let wordsToNumbers = transcription.split(separator: " ").compactMap { word -> [String]? in
                    let wordString = String(word)
                    if let numberString = wordToNumberMap[wordString] {
                        return numberString.map { String($0) }
                    } else if let number = Int(wordString) {
                        return String(number).map { String($0) }
                    } else {
                        return nil
                    }
                }.flatMap { $0 }

                var resultNumberString = ""
                var currentNumber = ""

                for digit in wordsToNumbers {
                    currentNumber.append(digit)
                    
                    if let number = Int(currentNumber) {
                        if number > 20 {
                            resultNumberString = String(digit)
                            currentNumber = String(digit)
                        } else {
                            resultNumberString = currentNumber
                        }
                    }
                }

                if !resultNumberString.isEmpty {
                    let containsOnlyNumbers = resultNumberString.allSatisfy { $0.isNumber }
                    if containsOnlyNumbers && !self.isStopped {
                        subject.onNext((resultNumberString, result.isFinal))
                        if result.isFinal {
                            self.restartSubject.onNext(()) // Trigger restart on final result
                            subject.onCompleted()
                        }
                    } else {
                        let error = NSError(domain: "SpeechRecognitionError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Bukan Angka"])
                        subject.onError(error)
                    }
                }
            } else {
                subject.onNext((nil, false))
            }
        }
    }
    
    private func handleError(_ error: Error, subject: PublishSubject<(String?, Bool)>) {
        print("Error occurred: \(error.localizedDescription)")
        subject.onError(error)
    }
}
