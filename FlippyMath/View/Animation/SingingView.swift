//
//  SingingView.swift
//  FlippyMath
//
//  Created by Rajesh Triadi Noftarizal on 19/08/24.
//

import SwiftUI

struct SingingView: View {
    @StateObject var viewModel: QuestionViewModel
    
    @State private var colorIndexes = [0, 0, 0, 0, 0]
    @State private var isAnimating = false
    @State private var randomOffsets: [CGSize] = Array(repeating: .zero, count: 5)
    @State private var scales: [CGFloat] = Array(repeating: 1.0, count: 5)
    @State private var throbbingTimers: [Timer] = []
    @State private var colorTimers: [Timer] = []
    @State private var currentTextIndex = 0
    @State private var textChangeTimer: Timer?
    
    // Colors to cycle through
    let colors: [Color] = [.pink, .indigo, .orange, .cyan]
    
    // Specify positions for each music note
    let positions: [(x: CGFloat, y: CGFloat)] = [
        (x: 200, y: 600),
        (x: 1000, y: 100),
        (x: 1100, y: 600),
        (x: 650, y: 750),
        (x: 300, y: 150)
    ]
    
    // Specify frame sizes for each music note
    let frames: [CGSize] = [
        CGSize(width: 150, height: 150),
        CGSize(width: 100, height: 100),
        CGSize(width: 100, height: 100),
        CGSize(width: 80, height: 80),
        CGSize(width: 100, height: 100)
    ]
    
    // Texts to display sequentially
    let texts = [
        "Selamat Ulang\ntahun, kami ucapkan",
        "Selamat panjang umur,\nkita 'kan doakan",
        "Selamat sejahtera,\nsehat, sentosa",
        "Selamat panjang umur \ndan bahagia",
        "Potong kuenya, \npotong kuenya,",
        "Potong kuenya, \nsekarang juga",
        "Sekarang juga, \nsekarang juga"
    ]
    
    // Function to start the animation
    func startAnimation(geometry: GeometryProxy) {
        isAnimating = true
        
        // Random movement animation
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            withAnimation(Animation.easeInOut(duration: 1)) {
                randomOffsets = randomOffsets.map { _ in
                    CGSize(
                        width: CGFloat.random(in: -geometry.size.width * 0.05...geometry.size.width * 0.05),
                        height: CGFloat.random(in: -geometry.size.height * 0.05...geometry.size.height * 0.05)
                    )
                }
            }
        }
        
        // Scale animation for throbbing effect with random timing
        throbbingTimers = (0..<5).map { index in
            Timer.scheduledTimer(withTimeInterval: Double.random(in: 0.5...1.5), repeats: true) { _ in
                withAnimation(Animation.easeInOut(duration: Double.random(in: 0.5...1.5)).repeatForever(autoreverses: true)) {
                    scales[index] = scales[index] == 1.0 ? 1.4 : 1.0
                }
            }
        }
        
        // Color change animation for each note
        colorTimers = (0..<5).map { index in
            Timer.scheduledTimer(withTimeInterval: Double.random(in: 0.5...1.5), repeats: true) { _ in
                withAnimation {
                    colorIndexes[index] = (colorIndexes[index] + 1) % colors.count
                }
            }
        }
        
        // Text change animation every 5 seconds
        textChangeTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                if currentTextIndex < texts.count - 1 {
                    currentTextIndex += 1
                } else {
                    textChangeTimer?.invalidate() // Stop the timer after reaching the last text
                }
            }
        }
    }
    
    var body: some View {
        QuestionLayout(viewModel: viewModel) { geometry in
            ZStack {
                ForEach(0..<5) { index in
                    Image("MusicNote\(index + 1).symbols")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: frames[index].width, height: frames[index].height)
                        .foregroundColor(colors[colorIndexes[index]])
                        .offset(randomOffsets[index])
                        .scaleEffect(scales[index])
                        .position(x: positions[index].x, y: positions[index].y)
                }
                
                Text(texts[currentTextIndex])
                    .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
                    .fontWeight(.bold)
                    .foregroundStyle(.blueSecondary)
                    .multilineTextAlignment(.center)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2.5 )
                    .animation(.easeInOut(duration: 1.0), value: currentTextIndex)
            }
            .onAppear {
                startAnimation(geometry: geometry)
            }
        }
    }
}

#Preview {
    SingingView(viewModel: QuestionViewModel(level: 1))
}
