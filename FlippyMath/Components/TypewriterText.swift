//
//  TypeWriter.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 16/08/24.
//

import Foundation
import SwiftUI

struct TypewriterText: View {
    @Binding var fullText: String
    @Binding var audioName: String
    var onComplete: (() -> Void)?
    @State private var displayedText: String = ""
    @State private var currentIndex: String.Index?
    var audioHelper = AudioHelper.shared
    @State private var typingInterval: TimeInterval = 0.08

    var body: some View {
        Text(displayedText)
            .font(.title)
            .padding()
            .onAppear {
                startTyping()
                audioHelper.playVoiceOver(named: audioName, fileType: "wav")
            }
            .onChange(of: fullText) { oldValue, newValue in
                startTyping()
                audioHelper.playVoiceOver(named: audioName, fileType: "wav")
            }
//            .onChange(of: audioName) { _ , _ in
//                updateTypingInterval()
//                audioHelper.playVoiceOver(named: audioName, fileType: "wav")
//            }.onAppear {
//                startTyping()
//                updateTypingInterval()
//                audioHelper.playVoiceOver(named: audioName, fileType: "wav")
//            }
    }
    
    func startTyping() {
        displayedText = ""
        currentIndex = fullText.startIndex
        Timer.scheduledTimer(withTimeInterval: typingInterval, repeats: true) { timer in
            if let index = currentIndex, index < fullText.endIndex {
                displayedText += String(fullText[index])
                currentIndex = fullText.index(after: index)
            } else {
                timer.invalidate()
                onComplete?()
            }
        }
    }
    
    func updateTypingInterval() {
        if let duration = audioHelper.getAudioDuration(named: audioName, fileType: "wav") {
            let totalCharacters = fullText.count
            if totalCharacters > 0 {
                typingInterval = duration / Double(totalCharacters)
            }
        }
    }
}


