//
//  SpeechRecognizerManager.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import Speech
import RxSwift

class SpeechRecognitionManager: NSObject, SpeechRecognizerService, SFSpeechRecognizerDelegate {
    
    private var audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "id_ID"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var isAudioSessionActive = false
    private var isTapInstalled = false
    private var isStopped = false
    
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
        
        let timeoutInSeconds: TimeInterval = 60
           DispatchQueue.main.asyncAfter(deadline: .now() + timeoutInSeconds) { [weak self] in
               guard let self = self else { return }
               if !self.isStopped && self.recognitionTask?.state != .completed {
                   print("Custom timeout occurred. Restarting recognition...")
                   self.handleError(NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: [NSLocalizedDescriptionKey: "Custom timeout"]), subject: subject)
               }
           }
        
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
        
        speechRecognizer.delegate = self
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
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
        subject.onCompleted()
        return subject
    }
    
    
    private func createRecognitionTask(subject: PublishSubject<(String?, Bool)>) -> SFSpeechRecognitionTask {
        return speechRecognizer!.recognitionTask(with: recognitionRequest!) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error in recognition task: \(error.localizedDescription)")
                self.handleError(error, subject: subject)
                subject.onCompleted()
                return
            }
            
            if let result = result {
                let transcription = result.bestTranscription.formattedString.lowercased()
                
                let wordToNumberMap: [String: String] = ["nol": "0", "enol" : "0", "kosong" : "0",
                                                         "satu": "1", "dua": "2", "tiga": "3", "empat": "4", "lima": "5", "nam" : "6",
                                                         "enam": "6", "tujuh": "7", "delapan": "8", "sembilan": "9",
                ]
                let wordsToNumbers = transcription.split(separator: " ").compactMap { word -> String? in
                    let wordString = String(word)
                    return wordToNumberMap[wordString] ?? (Int(wordString) != nil ? wordString : nil)
                }.last
                
                if let wordsToNumbers = wordsToNumbers {
                    let containsOnlyNumbers = wordsToNumbers.allSatisfy { $0.isNumber }
                    if containsOnlyNumbers && !self.isStopped {
                        subject.onNext((wordsToNumbers, result.isFinal))
                        if result.isFinal {
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
