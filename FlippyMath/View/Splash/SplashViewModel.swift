//
//  SplashViewModel.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 15/08/24.
//

import Foundation

class SplashViewModel : ObservableObject {
    @Inject(name: "CoreDataManager") var service: DataService
    @Inject var speechRecognitionService: SpeechRecognizerService
    
    init() {
    }
    
    func insertAllData() {
        service.insertAllData()
    }
}
