//
//  SpeechRecognizerManager.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import Speech
import RxSwift

class SpeechRecognitionManager: NSObject, SpeechRecognizerService, SFSpeechRecognizerDelegate {
    
    private var audioSession: AVAudioSession?
    private var audioEngine = AVAudioEngine()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var inputNode: AVAudioInputNode?
    private var isAudioSessionActive = false
    private var isTapInstalled = false
    private var isStopped = false
    
    func startRecognition() -> Observable<(String?, Bool)> {
        let subject = PublishSubject<(String?, Bool)>()
        
        audioSession = AVAudioSession.sharedInstance()
        
        if !isAudioSessionActive {
            do {
                try audioSession?.setCategory(.playAndRecord, mode: .default, options: [.duckOthers, .allowBluetooth, .defaultToSpeaker])
                try audioSession?.setActive(true, options: .notifyOthersOnDeactivation)
                isAudioSessionActive = true
            } catch {
                print("Couldn't configure the audio session properly")
                subject.onError(error)
                return subject
            }

        }
        
        inputNode = audioEngine.inputNode
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "id_ID"))
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable,
              let recognitionRequest = recognitionRequest,
              let inputNode = inputNode else {
            assertionFailure("Unable to start the speech recognition!")
            subject.onCompleted()
            return subject
        }
        
        speechRecognizer.delegate = self
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 512, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            recognitionRequest.append(buffer)
        }
        
        recognitionTask = createRecognitionTask(subject: subject)
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Couldn't start audio engine!")
            subject.onError(error)
            stopRecognition()
        }
        
        return subject
    }
    
    func stopRecognition() {
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    
    func deactivateAudioSession() {
        if isAudioSessionActive {
            try? audioSession?.setActive(false)
            audioSession = nil
            isAudioSessionActive = false
        }
    }
    
    private func createRecognitionTask(subject: PublishSubject<(String?, Bool)>) -> SFSpeechRecognitionTask {
        var _: String?
        
        return speechRecognizer!.recognitionTask(with: recognitionRequest!) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error in recognition task: \(error.localizedDescription)")
                self.handleError(error, subject: subject)
                subject.onCompleted()
                self.stopRecognition()
                return
            }
            
            if let result = result {
                let transcription = result.bestTranscription.formattedString.lowercased()
                
                print(transcription)
                let wordToNumberMap: [String: String] = ["nol": "0",
                                                         "satu": "1", "dua": "2", "tiga": "3", "empat": "4", "lima": "5",
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
