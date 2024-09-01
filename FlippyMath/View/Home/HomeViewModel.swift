//
//  HomeViewModel.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import RxSwift
import Speech
import Network

class HomeViewModel: ObservableObject {
    @Inject(name: "CoreDataManager") var service: DataService
    
    @Published var snowflakes: [Snowflake] = []
    @Published var animate = false
    @Published var isMusicOn = true
    @Published var isGranted = false
    @Published var showSettingsAlert = false
    @Published var alertMessage = ""
    @Published var showAlertInternet = false
    
    private let numberOfSnowflakes = 75
    private let disposeBag = DisposeBag()
    
    func createSnowflakes(in size: CGSize) {
        snowflakes.removeAll()
        for _ in 0..<numberOfSnowflakes {
            let xPosition = CGFloat.random(in: 0...size.width)
            let duration = Double.random(in: 5...15)
            let delay = Double.random(in: 0...20)
            let snowflakeSize = CGFloat.random(in: 10...30)
            let imageName = Bool.random() ? "snow1" : "snow2"
            let rotationDuration = Double.random(in: 3...10)
            let snowflake = Snowflake(xPosition: xPosition, duration: duration, delay: delay, size: snowflakeSize, imageName: imageName, rotationDuration: rotationDuration)
            snowflakes.append(snowflake)
        }
    }
    
    func requestPermissions() {
            var microphoneGranted = false
            var speechRecognitionGranted = false
            
            let group = DispatchGroup()
            
            // Check microphone permission status
            let microphoneStatus = AVAudioSession.sharedInstance().recordPermission
            if microphoneStatus == .granted {
                microphoneGranted = true
            } else if microphoneStatus == .denied {
                // Microphone permission was denied
                showSettingsAlert = true
                alertMessage = "Microphone access has been denied. Please enable it in settings."
            } else {
                group.enter()
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    microphoneGranted = granted
                    if !granted {
                        self.showSettingsAlert = true
                        self.alertMessage = "Microphone access has been denied. Please enable it in settings."
                    }
                    group.leave()
                }
            }
            
            // Check speech recognition permission status
            let speechStatus = SFSpeechRecognizer.authorizationStatus()
            if speechStatus == .authorized {
                speechRecognitionGranted = true
            } else if speechStatus == .denied || speechStatus == .restricted {
                // Speech recognition permission was denied or restricted
                showSettingsAlert = true
                alertMessage = "Speech recognition access has been denied or restricted. Please enable it in settings."
            } else {
                group.enter()
                SFSpeechRecognizer.requestAuthorization { authStatus in
                    switch authStatus {
                    case .authorized:
                        speechRecognitionGranted = true
                    case .denied, .restricted:
                        self.showSettingsAlert = true
                        self.alertMessage = "Speech recognition access has been denied or restricted. Please enable it in settings."
                    case .notDetermined:
                        print("Speech recognition not determined")
                    @unknown default:
                        print("Unknown authorization status")
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.checkInternetConnection { isConnected in
                    if isConnected {
                        self.isGranted = microphoneGranted && speechRecognitionGranted
                    } else {
                        self.showAlertInternet = true
                    }
                }
              
                print("Both permissions granted: \(self.isGranted)")
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
    
    func getLastCompletedLevel() -> Int {
        let completedQuestions = service.getInCompleteQuestion()
        if let lastCompleted = completedQuestions.first {
            print(lastCompleted.sequence)
            return Int(lastCompleted.sequence)
        } else {
            return 0
        }
    }
}
