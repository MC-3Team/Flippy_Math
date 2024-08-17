//
//  TypeWriter.swift
//  BambiniMath
//
//  Created by Enrico Maricar on 16/08/24.
//

import Foundation
import SwiftUI

struct TypewriterText: View {
    @Binding var fullText: String
    var onComplete: (() -> Void)?
    @State private var displayedText: String = ""
    @State private var currentIndex: String.Index?

    var body: some View {
        Text(displayedText)
            .font(.title)
            .padding()
            .onAppear(perform: startTyping)
            .onChange(of: fullText) { oldValue, newValue in
                startTyping()
            }
    }

    func startTyping() {
        displayedText = ""
        currentIndex = fullText.startIndex
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if let index = currentIndex, index < fullText.endIndex {
                displayedText += String(fullText[index])
                currentIndex = fullText.index(after: index)
            } else {
                timer.invalidate()
                onComplete?()
            }
        }
    }
}
