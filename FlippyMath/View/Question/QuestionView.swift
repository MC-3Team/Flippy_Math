//
//  QuestionView.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import SwiftUI

struct QuestionView: View {
    @StateObject private var viewModel: QuestionViewModel
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    init(sequenceLevel : Int, parameter: Parameter) {
        _viewModel = StateObject(wrappedValue: QuestionViewModel(sequenceLevel: sequenceLevel, parameter: parameter))
    }
    
    var isCompact: Bool {
        verticalSizeClass == .compact
    }
    
    var body: some View {
        QuestionLayout(viewModel: viewModel) { geometry in
            content(for: geometry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    ///MARK: Questions
    @ViewBuilder
    private func content(for geometry: GeometryProxy) -> some View {
        
        let _ = print(viewModel.currentQuestionIndex)
        switch viewModel.currentQuestionIndex {
        case 0:
            introView(geometry: geometry)
            // intro
        case 1:
            questionOneView(geometry: geometry)
            //teman
            
        case 2:
            questionTwoView(geometry: geometry)
            // topi
            
        case 3:
            questionThreeView(geometry: geometry)
            //balon
            
        case 4:
            SingingView(viewModel: viewModel)
            //menyanyi
            
        case 5:
            questionFourView(geometry: geometry)
            
            
        case 6:
            questionFiveView(geometry: geometry)
                .onAppear {
                    viewModel.updateFlyPositions(for: verticalSizeClass!)
                }
            
        case 7:
            questionSixView(geometry: geometry)
                .onAppear {
                    viewModel.updateBabyFoxPositions(for: verticalSizeClass!)
                }
            
        case 8:
            questionSevenView(geometry: geometry)
            
        case 9:
            questionEightView(geometry: geometry)
            
        case 10:
            outroView(geometry: geometry)
            
        default:
            defaultView(geometry: geometry)
        }
    }
    
    /// Mark: Intro
    @ViewBuilder
    private func introView(geometry: GeometryProxy) -> some View {
        IdleBalloonView()
    }
    
    
    
    /// MARK: Question 1
    @ViewBuilder
    private func questionOneView(geometry: GeometryProxy) -> some View {
        
        // Constants
        let penguinWidth = geometry.size.width * (isCompact ? 0.6 : 0.8)
        let penguinHeight = geometry.size.height * (isCompact ? 0.57 : 0.65)
        let unavailablePenguinWidth = geometry.size.width * (isCompact ? 0.08 : 0.1)
        let unavailablePenguinXPositions = isCompact ? [0.28, 0.71] : [0.22, 0.77]
        let unavailablePenguinYPosition = geometry.size.height * (isCompact ? 0.59 : 0.68)
        
        ZStack {
            PenguinsView()
                .frame(width: penguinWidth)
                .position(x: geometry.size.width / 2, y: penguinHeight)
            
            ForEach(0..<unavailablePenguinXPositions.count) { index in
                Image("Q1_UnavailablePenguin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: unavailablePenguinWidth)
                    .position(x: geometry.size.width * unavailablePenguinXPositions[index],
                              y: unavailablePenguinYPosition)
            }
        }
    }
    
    /// MARK: Question 2
    @ViewBuilder
    private func questionTwoView(geometry: GeometryProxy) -> some View {
        
        // Constants
        let imageWidth: CGFloat = isCompact ? geometry.size.width * 0.23 : geometry.size.width * 0.30
        let tableWidth: CGFloat = isCompact ? geometry.size.width * 0.35 : geometry.size.width * 0.45
        let imagePositionX: CGFloat = isCompact ? geometry.size.width * 0.235 : geometry.size.width / 5.5
        let imagePositionY: CGFloat = isCompact ? geometry.size.height * 0.46 : geometry.size.height * 0.52
        let tablePositionX: CGFloat = isCompact ? geometry.size.width * 0.23 : geometry.size.width * 0.175
        let tablePositionY: CGFloat = isCompact ? geometry.size.height * 0.13 : geometry.size.height * 0.18
        let penguinFrameWidth: CGFloat = isCompact ? geometry.size.width * 0.6 : geometry.size.width * 0.8
        let penguinPositionY: CGFloat = isCompact ? geometry.size.height * 0.58 : geometry.size.height * 0.65
        
        HStack {
            VStack {
                Image(viewModel.currentMessageIndex > 1 ? "" : "Q2_Hats")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageWidth)
                    .position(x: imagePositionX, y: imagePositionY)
                
                Image("Q2_Table")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: tableWidth)
                    .position(x: tablePositionX, y: tablePositionY)
            }
            
            (viewModel.currentMessageIndex > 1 ? AnyView(PenguinsHatView()) : AnyView(PenguinsView()))
                .frame(width: penguinFrameWidth)
                .position(x: geometry.size.width / 5.5, y: penguinPositionY)
        }
    }
    
    /// MARK: Question 3
    @ViewBuilder
    private func questionThreeView(geometry: GeometryProxy) -> some View {
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
    }
    
    /// MARK: Question 4
    @ViewBuilder
    private func questionFourView(geometry: GeometryProxy) -> some View {
        let isInitialMessage = viewModel.currentMessageIndex < 1
        let imageName = isInitialMessage ? "Q4_8Cakes" : "Q4_6Cakes"
        let frameWidth = geometry.size.width * (isCompact ? 0.5 : 0.75)
        let positionY = geometry.size.height * (isCompact ? 0.55 : 0.6)
        
        HStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: frameWidth)
                .position(x: geometry.size.width / 2, y: positionY)
        }
    }
    
    
    ///MARK: Question 5
    @ViewBuilder
    private func questionFiveView(geometry: GeometryProxy) -> some View {
        let cakeFrameWidth: CGFloat = isCompact ? geometry.size.width * 0.4 : geometry.size.width * 0.55
        let cakePositionY: CGFloat = isCompact ? geometry.size.height * 0.55 : geometry.size.height * 0.6
        let flyFrameWidth: CGFloat = isCompact ? geometry.size.width * 0.045 : geometry.size.width * 0.05
        
        ZStack {
            Image("Q5_2Cakes")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: cakeFrameWidth)
                .position(x: geometry.size.width / 2, y: cakePositionY)
            
            ForEach(0..<viewModel.flyCount, id: \.self) { index in
                Image("Q5_Fly\(index + 1)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: flyFrameWidth)
                    .position(x: viewModel.flyPosition(for: index, geometry: geometry).x,
                              y: viewModel.flyPosition(for: index, geometry: geometry).y)
                    .onAppear {
                        viewModel.flyAnimation(for: index, geometry: geometry)
                    }
            }
        }
    }
    
    
    ///MARK: Question 6
    @ViewBuilder
    private func questionSixView(geometry: GeometryProxy) -> some View {
        let arcticFoxFrameWidth = geometry.size.width * (isCompact ? 0.35 : 0.4)
        let babyFoxFrameWidth = geometry.size.width * (isCompact ? 0.4 : 0.5)
        
        ZStack {
            // Arctic Foxes
            HStack {
                ArcticFoxView(isPlay: $viewModel.isPlaying)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: arcticFoxFrameWidth)
                    .position(x: geometry.size.width / 3, y: geometry.size.height * (isCompact ? 0.53 : 0.6))
                    .onTapGesture {
                        viewModel.isPlaying.toggle()
                    }
                
                ArcticFoxView(isPlay: $viewModel.isPlaying)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: arcticFoxFrameWidth)
                    .position(x: geometry.size.width / (isCompact ? 6 : 5), y: geometry.size.height * (isCompact ? 0.55 : 0.6))
                    .onTapGesture {
                        viewModel.isPlaying.toggle()
                    }
            }
            
            // Baby Foxes
            ForEach(0..<viewModel.foxCount, id: \.self) { index in
                BabyFoxView(isPlay: $viewModel.isPlaying)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: babyFoxFrameWidth)
                    .position(x: viewModel.babyFoxPosition(for: index, geometry: geometry).x,
                              y: viewModel.babyFoxPosition(for: index, geometry: geometry).y)
                    .onTapGesture {
                        viewModel.isPlaying.toggle()
                    }
            }
        }
    }
    
    ///MARK: Question 7
    @ViewBuilder
    private func questionSevenView(geometry: GeometryProxy) -> some View {
        let ropeWidth = geometry.size.width * (isCompact ? 1.2 : 1.05)
        let pinataWidth = geometry.size.width * (isCompact ? 0.25 : 0.4)
        let pinataPositionY = geometry.size.height * (isCompact ? 0.43 : 0.5)
        let textFontSize: CGFloat = isCompact ? 16 : 48
        let candyPositionY = geometry.size.height * (isCompact ? 0.64 : 0.75)
        
        ZStack {
            if viewModel.currentMessageIndex < 3 {
                Image(isCompact ? "Q7_iPhonePinataRope" : "Q7_PinataRope")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: ropeWidth)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * (isCompact ? 0.26 : 0.16))
                    .allowsHitTesting(false)
            }

            if viewModel.currentMessageIndex < 2 {
                Image("Q7_Pinata")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: pinataWidth)
                        .position(x: geometry.size.width / 2, y: pinataPositionY)
                        .scaleEffect(viewModel.isTapped ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: viewModel.isTapped)
                        .rotationEffect(.degrees(-10))
                        .onTapGesture {
                            if viewModel.currentMessageIndex == 1 {
                                viewModel.handleTap(tapThreshold: 5, tapDelay: 0.2, upperLimit: 2, isOutro: false)
                            }
                        }
                
                if viewModel.currentMessageIndex == 1 {
                    Text("Tekan 5x untuk memecahkan pinata!")
                        .font(.custom("PilcrowRoundedVariable-Regular", size: textFontSize))
                        .foregroundStyle(.black)
                        .opacity(0.5)
                        .fontWeight(.bold)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * (isCompact ? 0.75 : 0.85))
                }
            } else if viewModel.currentMessageIndex < 3 {
                PinataView()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * (isCompact ? 0.45 : 0.8))
                    .position(x: geometry.size.width / 2, y: pinataPositionY)
            } else if viewModel.currentMessageIndex < 4 {
                Image("Q7_20Candies")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * (isCompact ? 0.7 : 0.9))
                    .position(x: geometry.size.width / 2, y: candyPositionY)
            } else {
                Image("Q7_15Candies")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * (isCompact ? 0.65 : 0.7))
                    .position(x: geometry.size.width / 2, y: geometry.size.height * (isCompact ? 0.62 : 0.75))
            }
        }
    }
    
    ///MARK: Question 8
    @ViewBuilder
    private func questionEightView(geometry: GeometryProxy) -> some View {
        let isOpen = viewModel.currentMessageIndex >= 2
        let frameWidth = geometry.size.width * (isCompact ? (isOpen ? 0.38 : 0.5) : (isOpen ? 0.6 : 0.7))
        let positionY = geometry.size.height * (isCompact ? (isOpen ? 0.55 : 0.45) : (isOpen ? 0.6 : 0.55))
        
        PolarBearView(key: "isOpen", value: isOpen)
            .frame(width: frameWidth)
            .position(x: geometry.size.width / 2, y: positionY)
    }

    
    ///MARK: Outro
    @ViewBuilder
    private func outroView(geometry: GeometryProxy) -> some View {
        // Constants for sizing and positioning based on `isCompact`
        let bannerWidth = geometry.size.width * 0.65
        let bannerPositionY = geometry.size.width * 0.065
        let foxWidth = geometry.size.width * (isCompact ? 0.4 : 0.45)
        let foxPositionX = geometry.size.width * (isCompact ? 0.8 : 0.9)
        let foxPositionY = geometry.size.height * (isCompact ? 0.55 : 0.64)
        let babyFoxWidth = geometry.size.width * (isCompact ? 0.4 : 0.5)
        let babyFoxPositionX = geometry.size.width * (isCompact ? 0.72 : 0.8)
        let babyFoxPositionY = geometry.size.height * (isCompact ? 0.7 : 0.75)
        let penguinsWidth = geometry.size.width * (isCompact ? 0.6 : 0.85)
        let penguinsPositionY = geometry.size.height * (isCompact ? 0.6 : 0.64)
        let polarBearWidth = geometry.size.width * (isCompact ? 0.4 : 0.6)
        let polarBearPositionX = geometry.size.width * (isCompact ? 0.2 : 0.14)
        let polarBearPositionY = geometry.size.height * (isCompact ? 0.55 : 0.62)
        let giftWidth = geometry.size.width * (isCompact ? 0.33 : 0.45)
        let giftPositionY = geometry.size.height * (isCompact ? 0.4 : 0.45)
        let textFontSize: CGFloat = isCompact ? 16 : 48
        let textPositionY = geometry.size.height * (isCompact ? 0.76 : 0.85)

        ZStack {
            // Show different content based on `currentMessageIndex`
            if viewModel.currentMessageIndex < 2 || viewModel.currentMessageIndex == 4 {
                Image("Outro_HBD_Banner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: bannerWidth)
                    .position(x: geometry.size.width / 2, y: bannerPositionY)
                    .allowsHitTesting(false)

                IdleBalloonView()

                // Arctic Fox View
                ArcticFoxView(isPlay: .constant(true))
                    .frame(width: foxWidth)
                    .position(x: foxPositionX, y: foxPositionY)

                // Baby Fox View
                BabyFoxView(isPlay: .constant(true))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: babyFoxWidth)
                    .position(x: babyFoxPositionX, y: babyFoxPositionY)

                // Penguins View
                PenguinsView()
                    .frame(width: penguinsWidth)
                    .position(x: geometry.size.width / 2, y: penguinsPositionY)

                // Polar Bear View
                PolarBearOnlyView()
                    .frame(width: polarBearWidth)
                    .position(x: polarBearPositionX, y: polarBearPositionY)

            } else if viewModel.currentMessageIndex == 2 {
                // Gift Interaction View
                Image("Outro_Gift")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: giftWidth)
                    .position(x: geometry.size.width / 2, y: giftPositionY)
                    .scaleEffect(viewModel.isTapped ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.4), value: viewModel.isTapped)
                    .onTapGesture {
                        if viewModel.currentMessageIndex == 2 {
                            viewModel.handleTap(tapDelay: 0.5, upperLimit: 3, isOutro: true)
                        }
                    }

                // Gift instruction text
                Text("Tekan Hadiah untuk membuka!")
                    .font(.custom("PilcrowRoundedVariable-Regular", size: textFontSize))
                    .foregroundStyle(.black)
                    .opacity(0.5)
                    .fontWeight(.bold)
                    .position(x: geometry.size.width / 2, y: textPositionY)

            } else if viewModel.currentMessageIndex == 3 {
                // Starburst Animation View
                Group {
                    Image("Outro_Starburst")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * (isCompact ? 0.27 : 0.7))
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
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
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width * (isCompact ? 0.4 : 0.65))
            }
        }
    }
    
    ///MARK: Default
    @ViewBuilder
    private func defaultView(geometry: GeometryProxy) -> some View {
        Image("DefaultImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geometry.size.width * 0.70)
            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.65)
    }
}

//#Preview {
//    QuestionView(sequenceLevel: 1, parameter: .home)
//}
