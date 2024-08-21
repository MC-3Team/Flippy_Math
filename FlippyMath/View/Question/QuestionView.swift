//
//  QuestionView.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import SwiftUI

struct QuestionView: View {
    @StateObject private var viewModel: QuestionViewModel
    
    init(sequenceLevel : Int, parameter: Parameter) {
        _viewModel = StateObject(wrappedValue: QuestionViewModel(sequenceLevel: sequenceLevel, parameter: parameter))
    }
    
    var body: some View {
            QuestionLayout(viewModel: viewModel) { geometry in
                VStack {
                    switch viewModel.currentQuestionIndex {
                    case 0:
                        VStack {
                            
                        }
                        
                    case 1:
                        ZStack {
                            Image("Q1_UnavailablePenguin")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.1)
                                .position(x: geometry.size.width * 0.24, y: geometry.size.height * 0.665)
                            
                            Image("Q1_UnavailablePenguin")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.1)
                                .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.665)
                            
                            PenguinsView()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.70)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.65)
                        }
                        
                    case 2:
                        HStack {
                            VStack {
                                Image(viewModel.currentMessageIndex > 1 ? "" : "Q2_Hats")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.30)
                                    .position(x: geometry.size.width / 5.5, y: geometry.size.height * 0.45)
                                
                                Image("Q2_Table")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.45)
                                    .position(x: geometry.size.width / 5, y: geometry.size.height * 0.1)
                            }
                            
                            Image(viewModel.currentMessageIndex > 1 ? "Q2_PenguinWithHats" : "Q2_Penguins")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.55)
                                .position(x: geometry.size.width / 5.5, y: geometry.size.height * (viewModel.currentMessageIndex > 1 ? 0.60 : 0.65))
                        }
                        
                    case 3:
                        VStack {
                            switch viewModel.currentMessageIndex {
                            case ..<2:
                                IdleBalloonView()
                            case 2:
                                FlyingBalloonView()
                            default:
                                IdleBalloon2View()
                            }
                        }
                        
                    case 4:
                        HStack {
                            if viewModel.currentMessageIndex < 1 {
                                Image("Q4_8Cakes")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.75)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                            } else {
                                Image("Q4_6Cakes")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.75)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                            }
                        }
                        
                    case 5:
                        ZStack {
                            Image("Q5_2Cakes")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.55)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                            
                            ForEach(0..<viewModel.flyCount, id: \.self) { index in
                                Image("Q5_Fly\(index + 1)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.05)
                                    .position(x: viewModel.flyPosition(for: index, geometry: geometry).x,
                                              y: viewModel.flyPosition(for: index, geometry: geometry).y)
                                    .onAppear {
                                        viewModel.flyAnimation(for: index, geometry: geometry)
                                    }
                            }
                        }
                        
                    case 6:
                        ZStack {
                            HStack {
                                ArcticFoxView(isPlay: $viewModel.isPlaying)
                                    .aspectRatio(contentMode: .fit)
                                    .position(x: geometry.size.width / 3, y: geometry.size.height * 0.6)
                                    .onTapGesture {
                                        viewModel.isPlaying.toggle()
                                    }
                                
                                ArcticFoxView(isPlay: $viewModel.isPlaying)
                                    .aspectRatio(contentMode: .fit)
                                    .position(x: geometry.size.width / 5, y: geometry.size.height * 0.6)
                                    .onTapGesture {
                                        viewModel.isPlaying.toggle()
                                    }
                            }
                            
                            ForEach(0..<viewModel.foxCount, id: \.self) { index in
                                BabyFoxView(isPlay: $viewModel.isPlaying)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.5)
                                    .position(x: viewModel.babyFoxPosition(for: index, geometry: geometry).x,
                                              y: viewModel.babyFoxPosition(for: index, geometry: geometry).y)
                                    .onTapGesture {
                                        viewModel.isPlaying.toggle()
                                    }
                            }
                        }
                        
                        
                    case 7:
                        ZStack {
                            if viewModel.currentMessageIndex < 3 {
                                Image("Q7_PinataRope")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 1.05)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.16)
                            }
                            
                            if viewModel.currentMessageIndex < 2 {
                                Image("Q7_Pinata")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.40)
                                    .position(x: geometry.size.width * 0.505, y: geometry.size.height * 0.505)
                                    .scaleEffect(viewModel.isTapped ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: viewModel.isTapped)
                                    .rotationEffect(.degrees(-10))
                                    .onTapGesture {
                                        if viewModel.currentMessageIndex == 1 {
                                            viewModel.handleTap(tapThreshold: 3, tapDelay: 0.2)
                                        }
                                    }
                            } else if viewModel.currentMessageIndex < 3 {
                                PinataView()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.8)
                                    .position(x: geometry.size.width * 0.515, y: geometry.size.height * 0.495)
                            } else if viewModel.currentMessageIndex < 4 {
                                Image("Q7_20Candies")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.9)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                            } else {
                                Image("Q7_15Candies")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.70)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                            }
                        }
                        
                    case 8:
                        if viewModel.currentMessageIndex < 2 {
                            PolarBearView(key: "isOpen", value: false)
                        } else {
                            PolarBearView(key: "isOpen", value: true)
                        }
                        
                    case 9:
                        ZStack {
                            Image("Outro_Background")
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                            
                            if viewModel.currentMessageIndex < 2 || viewModel.currentMessageIndex == 4 {
                                Image("Outro_HBD_Banner")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.65)
                                    .position(x: geometry.size.width / 2, y: geometry.size.width * 0.065)
                                
                                IdleBalloonView()
                                
                                ArcticFoxView(isPlay: .constant(true))
                                    .frame(width: geometry.size.width * 0.45)
                                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.64)
                                
                                BabyFoxView(isPlay: .constant(true))
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.5)
                                    .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.75)
                                
                                PenguinsView()
                                    .frame(width: geometry.size.width * 0.85)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.64)
                                
                                PolarBearOnlyView()
                                    .frame(width: geometry.size.width * 0.6)
                                    .position(x: geometry.size.width * 0.14, y: geometry.size.height * 0.62)
                                
                            } else if viewModel.currentMessageIndex == 2 {
                                Image("Outro_Gift")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.45)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.45)
                                    .scaleEffect(viewModel.isTapped ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 0.4), value: viewModel.isTapped)
                                    .onTapGesture {
                                        if viewModel.currentMessageIndex == 2 {
                                            viewModel.handleTap(tapThreshold: 1, tapDelay: 0.5)
                                        }
                                    }
                            } else if viewModel.currentMessageIndex == 3 {
                                Group {
                                    Image("Outro_Starburst")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: geometry.size.width * 0.7)
                                        .rotationEffect(.degrees(viewModel.rotation))
                                        .scaleEffect(viewModel.scale)
                                }
                                .onAppear {
                                    withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
                                        viewModel.rotation = 360
                                    }
                                    withAnimation(Animation.easeInOut(duration: 2)) {
                                        viewModel.scale = 1.5
                                    }
                                }
                                
                                RewardAnimationView()
                            }
                        }
                        
                    default:
                        Image("DefaultImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.70)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.65)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
}

//#Preview {
//    QuestionView(viewModel: QuestionViewModel(level: 2))
//}

struct FlyPreview: View {
    @State private var currentMessageIndex = 0
    
    @State private var flyPositions: [(x: CGFloat, y: CGFloat)] = [
        (x: 0.1, y: 0.7),
        (x: 0.16, y: 0.4),
        (x: 0.2, y: 0.8),
        (x: 0.3, y: 0.35),
        (x: 0.5, y: 0.55),
        (x: 0.45, y: 0.81),
        (x: 0.8, y: 0.8),
        (x: 0.75, y: 0.4),
        (x: 0.9, y: 0.6)
    ]
    
    var flyCount: Int {
        return (currentMessageIndex >= 4) ? 2 : flyPositions.count
    }
    
    func flyPosition(for index: Int, geometry: GeometryProxy) -> (x: CGFloat, y: CGFloat) {
        let position = flyPositions[index]
        return (x: geometry.size.width * position.x, y: geometry.size.height * position.y)
    }
    
    func flyAnimation(for index: Int, geometry: GeometryProxy) {
        let startPosition = flyPositions[index]
        let animation = Animation.easeInOut(duration: Double.random(in: 2...5))
            .repeatForever(autoreverses: true)
        
        withAnimation(animation) {
            flyPositions[index] = (
                x: startPosition.x + CGFloat.random(in: -0.1...0.1),
                y: startPosition.y + CGFloat.random(in: -0.1...0.1)
            )
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Q5_2Cakes")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * 0.55)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                
                ForEach(0..<flyCount, id: \.self) { index in
                    Image("Q5_Fly\(index + 1)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.05)
                        .position(
                            x: flyPosition(for: index, geometry: geometry).x,
                            y: flyPosition(for: index, geometry: geometry).y
                        )
                        .onAppear {
                            flyAnimation(for: index, geometry: geometry)
                        }
                }
            }
        }
    }
}

#Preview {
    FlyPreview()
}

struct FoxPreview: View {
    @State private var currentMessageIndex = 4
    
    @State private var babyFoxPositions: [(x: CGFloat, y: CGFloat)] = [
        (x: 0.476, y: 0.74),
        (x: 0.588, y: 0.76),
        (x: 0.222, y: 0.70),
        (x: 0.125, y: 0.74),
        (x: 0.8, y: 0.75),
        (x: 0.909, y: 0.7)
    ]
    
    @State private var isPlaying: Bool = false
    
    var foxCount: Int {
        return (currentMessageIndex < 3) ? 2 : babyFoxPositions.count
    }
    
    func babyFoxPosition(for index: Int, geometry: GeometryProxy) -> (x: CGFloat, y: CGFloat) {
        let position = babyFoxPositions[index]
        return (x: geometry.size.width * position.x, y: geometry.size.height * position.y)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    ArcticFoxView(isPlay: $isPlaying)
                        .aspectRatio(contentMode: .fit)
                        .position(x: geometry.size.width / 3, y: geometry.size.height * 0.6)
                        .onTapGesture {
                            isPlaying.toggle()
                        }
                    
                    ArcticFoxView(isPlay: $isPlaying)
                        .aspectRatio(contentMode: .fit)
                        .position(x: geometry.size.width / 5, y: geometry.size.height * 0.6)
                        .onTapGesture {
                            isPlaying.toggle()
                        }
                }
                
                ForEach(0..<foxCount, id: \.self) { index in
                    BabyFoxView(isPlay: $isPlaying)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.5)
                        .position(x: babyFoxPosition(for: index, geometry: geometry).x,
                                  y: babyFoxPosition(for: index, geometry: geometry).y)
                        .onTapGesture {
                            isPlaying.toggle()
                        }
                }
            }
        }
    }
}

#Preview {
    FoxPreview()
}

struct PinataaView: View {
    @State private var currentMessageIndex = 1
    @State private var isTapped = false
    @State private var tapCount = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                if currentMessageIndex < 3 {
                    Image("Q7_PinataRope")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 1.05)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.16)
                }
                
                if currentMessageIndex < 2 {
                    Image("Q7_Pinata")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.40)
                        .position(x: geometry.size.width * 0.505, y: geometry.size.height * 0.505)
                        .scaleEffect(isTapped ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: isTapped)
                        .rotationEffect(.degrees(-10))
                        .onTapGesture {
                            if currentMessageIndex == 1 {
                                handleTap()
                            }
                        }
                } else if currentMessageIndex < 3 {
                    PinataView()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.8)
                        .position(x: geometry.size.width * 0.515, y: geometry.size.height * 0.495)
                } else if currentMessageIndex < 4 {
                    Image("Q7_20Candies")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.9)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                } else {
                    Image("Q7_15Candies")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.70)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                }
            }
        }
    }
    
    private func handleTap() {
        isTapped = true
        tapCount += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.isTapped = false
            if self.tapCount >= 3 {
                self.tapCount = 0
                self.moveToNextMessage()
            }
        }
    }
    
    private func moveToNextMessage() {
        if currentMessageIndex < 2 {
            currentMessageIndex += 1
        }
    }
}

#Preview {
    PinataaView()
}

struct OutroView: View {
    @State private var currentMessageIndex = 1
    @State private var isTapped = false
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.5
    
    func handleTap() {
        isTapped = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isTapped = false
            moveToNextMessage()
        }
    }
    
    private func moveToNextMessage() {
        if currentMessageIndex == 2 {
            currentMessageIndex += 1
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Outro_Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                if currentMessageIndex < 2 || currentMessageIndex == 4 {
                    Image("Outro_HBD_Banner")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.65)
                        .position(x: geometry.size.width / 2, y: geometry.size.width * 0.065)
                    
                    IdleBalloonView()
                    
                    ArcticFoxView(isPlay: .constant(true))
                        .frame(width: geometry.size.width * 0.45)
                        .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.64)
                    
                    BabyFoxView(isPlay: .constant(true))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.5)
                        .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.75)
                    
                    PenguinsView()
                        .frame(width: geometry.size.width * 0.85)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.64)
                    
                    PolarBearOnlyView()
                        .frame(width: geometry.size.width * 0.6)
                        .position(x: geometry.size.width * 0.14, y: geometry.size.height * 0.62)
                    
                } else if currentMessageIndex == 2 {
                    Image("Outro_Gift")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.45)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.45)
                        .scaleEffect(isTapped ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.4), value: isTapped)
                        .onTapGesture {
                            if currentMessageIndex == 2 {
                                handleTap()
                            }
                        }
                } else if currentMessageIndex == 3 {
                    Group {
                        Image("Outro_Starburst")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.7)
                            .rotationEffect(.degrees(rotation))
                            .scaleEffect(scale)
                    }
                    .onAppear {
                        withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
                            rotation = 360
                        }
                        withAnimation(Animation.easeInOut(duration: 2)) {
                            scale = 1.5
                        }
                    }
                    
                    RewardAnimationView()
                }
            }
        }
    }
}

#Preview {
    OutroView()
}
