//
//  SingingView.swift
//  FlippyMath
//
//  Created by Rajesh Triadi Noftarizal on 19/08/24.
//

import SwiftUI

struct TextKaraoke{
    var text : String
    var duration : TimeInterval
}

struct SingingView: View {
    @ObservedObject var viewModel: QuestionViewModel
    @EnvironmentObject var audioHelper: AudioHelper
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @State private var colorIndexes = [0, 0, 0, 0, 0]
    @State private var isAnimating = false
    @State private var randomOffsets: [CGSize] = Array(repeating: .zero, count: 5)
    @State private var scales: [CGFloat] = Array(repeating: 1.0, count: 5)
    @State private var throbbingTimers: [Timer] = []
    @State private var colorTimers: [Timer] = []
    @State private var currentTextIndex = 0
    @State private var currentText = ""
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
    
    // Specify positions for each music note
    let positionsIphone: [(x: CGFloat, y: CGFloat)] = [
        (x: 50, y: 160),
        (x: 500, y: 40),
        (x: 680, y: 210),
        (x: 330, y: 250),
        (x: 300, y: 40),

    ]
    
    // Specify frame sizes for each music note
    let frames: [CGSize] = [
        CGSize(width: 150, height: 150),
        CGSize(width: 100, height: 100),
        CGSize(width: 100, height: 100),
        CGSize(width: 80, height: 80),
        CGSize(width: 100, height: 100)
    ]
    
    // Specify frame sizes for each music note
    let framesIphone: [CGSize] = [
        CGSize(width: 70, height: 70),
        CGSize(width: 50, height: 50),
        CGSize(width: 50, height: 50),
        CGSize(width: 40, height: 40),
        CGSize(width: 50, height: 50)
    ]
    
    let textKaraoke = [
        TextKaraoke(text: "", duration: 6.00),
        TextKaraoke(text: "Selamat ulang\ntahun, kami ucapkan", duration: 11.36),
        TextKaraoke(text: "Selamat panjang umur,\nkita 'kan doakan", duration: 10.64),
        TextKaraoke(text: "Selamat sejahtera,\nsehat, sentosa", duration: 10.64),
        TextKaraoke(text: "Selamat panjang umur \ndan bahagia", duration: 9.00),
        TextKaraoke(text: "", duration: 1.64),
        TextKaraoke(text: "Potong kuenya, \npotong kuenya,", duration: 5.0),
        TextKaraoke(text: "Potong kuenya, \nsekarang juga", duration: 5.0),
        TextKaraoke(text: "Sekarang juga, \nsekarang juga", duration: 9.0),
        TextKaraoke(text: "", duration: 1.0)
        
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
        
    }
    
    func showTextsSequentially() {
        guard currentTextIndex < textKaraoke.count else { return }
        
        currentText = textKaraoke[currentTextIndex].text
        
        DispatchQueue.main.asyncAfter(deadline: .now() + textKaraoke[currentTextIndex].duration) {
            currentTextIndex += 1
            showTextsSequentially()
        }
    }
    
    var body: some View {
        GeometryReader{ geometry in
            if viewModel.currentMessageIndex == 1{
                ZStack {
                    ForEach(0..<5) { index in
                        Image("MusicNote\(index + 1).symbols")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: verticalSizeClass == .compact ? framesIphone[index].width : frames[index].width, height: verticalSizeClass == .compact ? framesIphone[index].height : frames[index].width)
                            .foregroundColor(colors[colorIndexes[index]])
                            .offset(randomOffsets[index])
                            .scaleEffect(scales[index])
                            .position(x: verticalSizeClass == .compact ? positionsIphone[index].x  : positions[index].x , y: verticalSizeClass == .compact ? positionsIphone[index].y  : positions[index].y )
                    }
                    
                    
                    Text(currentText)
                        .font(.custom("PilcrowRoundedVariable-Regular", size: verticalSizeClass == .compact ? 64 : 96))
                        .fontWeight(.bold)
                        .foregroundStyle(.blueSecondary)
                        .multilineTextAlignment(.center)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2.5 )
                        .onAppear {
                            showTextsSequentially()
                        }
                }
                .onAppear {
                    startAnimation(geometry: geometry)
                    audioHelper.stopMusicQuestion()
                    audioHelper.setVoiceVolume(2.0)
                    
                    if let audioTime = audioHelper.getAudioDuration(named: "Selamat Ulang Tahun", fileType: "wav") {
                        let dispatchTime = DispatchTime.now() + audioTime
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                            viewModel.checkAnswerAndAdvance()
                        }
                    } else {
                        // Handle the case where the duration couldn't be retrieved
                        print("Failed to get audio duration.")
                    }
                }
                .onDisappear(){
                    audioHelper.setVoiceVolume(1.0)
                    audioHelper.playMusicQuestion(named: "comedy-kids", fileType: "mp3")
                }
                
                
            }
            else{
                ForEach(0..<5) { index in
                    Image("MusicNote\(index + 1).symbols")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: verticalSizeClass == .compact ? framesIphone[index].width : frames[index].width, height: verticalSizeClass == .compact ? framesIphone[index].height : frames[index].width)
                        .foregroundColor(colors[colorIndexes[index]])
                        .offset(randomOffsets[index])
                        .scaleEffect(scales[index])
                        .position(x: verticalSizeClass == .compact ? positionsIphone[index].x  : positions[index].x , y: verticalSizeClass == .compact ? positionsIphone[index].y  : positions[index].y )
                        .onAppear {
                            startAnimation(geometry: geometry)
                        }
                }
            }
        }
    }
}
//
//#Preview {
//    SingingView(viewModel: QuestionViewModel(sequenceLevel: 0, parameter: .home))
//}
