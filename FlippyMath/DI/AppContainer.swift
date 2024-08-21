//
//  AppContainer.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import Foundation
import Swinject

extension Container {
    static var AppContainer : Container {
        let container = Container()
        
        container.register(DataService.self, name: "CoreDataManager") { _ in
            CoreDataManager()
        }
        
        container.register(SoundAnalysisService.self) { _ in
            SoundAnalysisManager()
        }
        
        container.register(SpeechRecognizerService.self) { _ in
             SpeechRecognitionManager()
        }.inObjectScope(.container)
        
        return container
    }
}
