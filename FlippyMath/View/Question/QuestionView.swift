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
        let imageWidth = geometry.size.width * (isCompact ? 0.23 : 0.30)
        let tableWidth = geometry.size.width * (isCompact ? 0.35 : 0.45)
        let imagePositionX = geometry.size.width * (isCompact ? 0.235 : 1/5.5)
        let imagePositionY = geometry.size.height * (isCompact ? 0.46 : 0.435)
        let tablePositionX = geometry.size.width * (isCompact ? 0.23 : 0.175)
        let tablePositionY = geometry.size.height * (isCompact ? 0.13 : 0.1)
        let penguinFrameWidth = geometry.size.width * (isCompact ? 0.6 : 0.8)
        let penguinPositionY = geometry.size.height * (isCompact ? 0.58 : 0.65)
        
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
        if isCompact {
            ZStack {
                HStack {
                    ArcticFoxView(isPlay: $viewModel.isPlaying)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.35)
                        .position(x: geometry.size.width / 3, y: geometry.size.height * 0.53)
                        .onTapGesture {
                            viewModel.isPlaying.toggle()
                        }
                    
                    ArcticFoxView(isPlay: $viewModel.isPlaying)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.35)
                        .position(x: geometry.size.width / 6, y: geometry.size.height * 0.55)
                        .onTapGesture {
                            viewModel.isPlaying.toggle()
                        }
                }
                
                ForEach(0..<viewModel.foxCount, id: \.self) { index in
                    BabyFoxView(isPlay: $viewModel.isPlaying)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.4)
                        .position(x: viewModel.babyFoxPosition(for: index, geometry: geometry).x,
                                  y: viewModel.babyFoxPosition(for: index, geometry: geometry).y)
                        .onTapGesture {
                            viewModel.isPlaying.toggle()
                        }
                }
            }
        } else {
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
        }
    }
    
    ///MARK: Question 7
    @ViewBuilder
    private func questionSevenView(geometry: GeometryProxy) -> some View {
        if isCompact {
            ZStack {
                if viewModel.currentMessageIndex < 3 {
                    Image("Q7_iPhonePinataRope")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 1.2)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.26)
                        .allowsHitTesting(false)
                    
                }
                
                if viewModel.currentMessageIndex < 2 {
                    Image("Q7_Pinata")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.25)
                        .position(x: geometry.size.width * 0.502, y: geometry.size.height * 0.45)
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
                            .font(.custom("PilcrowRoundedVariable-Regular", size: 16))
                            .foregroundStyle(.black)
                            .opacity(0.5)
                            .fontWeight(.bold)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                    }
                    
                    
                } else if viewModel.currentMessageIndex < 3 {
                    PinataView()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.45)
                        .position(x: geometry.size.width * 0.505, y: geometry.size.height * 0.45)
                } else if viewModel.currentMessageIndex < 4 {
                    Image("Q7_20Candies")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.7)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.64)
                } else {
                    Image("Q7_15Candies")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.65)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.62)
                }
            }
        } else {
            ZStack {
                if viewModel.currentMessageIndex < 3 {
                    Image("Q7_PinataRope")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 1.05)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.16)
                        .allowsHitTesting(false)
                    
                }
                
                if viewModel.currentMessageIndex < 2 {
                    Image("Q7_Pinata")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.40)
                        .position(x: geometry.size.width * 0.505, y: geometry.size.height * 0.5)
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
                            .font(.custom("PilcrowRoundedVariable-Regular", size: 48))
                            .foregroundStyle(.black)
                            .opacity(0.5)
                            .fontWeight(.bold)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.85)
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
        }
    }
    
    ///MARK: Question 8
    @ViewBuilder
    private func questionEightView(geometry: GeometryProxy) -> some View {
        if isCompact {
            if viewModel.currentMessageIndex < 2 {
                PolarBearView(key: "isOpen", value: false)
                    .frame(width: geometry.size.width * 0.5)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.45)
            } else {
                PolarBearView(key: "isOpen", value: true)
                    .frame(width: geometry.size.width * 0.38)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.55)
            }
        } else {
            if viewModel.currentMessageIndex < 2 {
                PolarBearView(key: "isOpen", value: false)
                    .frame(width: geometry.size.width * 0.7)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.55)
            } else {
                PolarBearView(key: "isOpen", value: true)
                    .frame(width: geometry.size.width * 0.6)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
            }
        }
    }
    
    ///MARK: Outro
    @ViewBuilder
    private func outroView(geometry: GeometryProxy) -> some View {
        
        if isCompact {
            ZStack {
                //                Image("Outro_iPhoneBackground")
                //                    .resizable()
                //                    .frame(
                //                        width: geometry.size.width * 1.2,
                //                        height: geometry.size.height * 1.2
                //                    )
                //                    .position(
                //                        x: geometry.size.width / 2,
                //                        y: geometry.size.height / 2
                //                    )
                //
                if viewModel.currentMessageIndex < 2 || viewModel.currentMessageIndex == 4 {
                    Image("Outro_HBD_Banner")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.65)
                        .position(x: geometry.size.width / 2, y: geometry.size.width * 0.065)
                        .allowsHitTesting(false)
                    
                    IdleBalloonView()
                    
                    ArcticFoxView(isPlay: .constant(true))
                        .frame(width: geometry.size.width * 0.4)
                        .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.55)
                    
                    BabyFoxView(isPlay: .constant(true))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.4)
                        .position(x: geometry.size.width * 0.72, y: geometry.size.height * 0.7)
                    
                    PenguinsView()
                        .frame(width: geometry.size.width * 0.6)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                    
                    PolarBearOnlyView()
                        .frame(width: geometry.size.width * 0.4)
                        .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.55)
                    
                } else if viewModel.currentMessageIndex == 2 {
                    Image("Outro_Gift")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.33)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.4)
                        .scaleEffect(viewModel.isTapped ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.4), value: viewModel.isTapped)
                        .onTapGesture {
                            if viewModel.currentMessageIndex == 2 {
                                viewModel.handleTap(tapDelay: 0.5, upperLimit: 3, isOutro: true)
                            }
                        }
                    
                    Text("Tekan Hadiah untuk membuka!")
                        .font(.custom("PilcrowRoundedVariable-Regular", size: 16))
                        .foregroundStyle(.black)
                        .opacity(0.5)
                        .fontWeight(.bold)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.76)
                    
                } else if viewModel.currentMessageIndex == 3 {
                    Group {
                        Image("Outro_Starburst")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.27)
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
                        .frame(width: geometry.size.width * 0.4)
                }
            }
        } else {
            ZStack {
                //                Image("Outro_Background")
                //                    .resizable()
                //                    .scaledToFill()
                //                    .ignoresSafeArea()
                
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
                                viewModel.handleTap(tapDelay: 0.5, upperLimit: 3, isOutro: true)
                            }
                        }
                    
                    Text("Tekan Hadiah untuk membuka!")
                        .font(.custom("PilcrowRoundedVariable-Regular", size: 48))
                        .foregroundStyle(.black)
                        .opacity(0.5)
                        .fontWeight(.bold)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.85)
                    
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
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.65)
                }
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


//preview ngapa banyak gini anjing, device udah ada tinggal run
struct Question1View: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var isCompact: Bool {
        verticalSizeClass == .compact
    }
    
    // Constants
    let backgroundScale: CGFloat = 1.2
    
    ///MARK: Bottom View
    @State var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    
    var body: some View {
        GeometryReader { geometry in
            // Constants
            let penguinWidth = geometry.size.width * (isCompact ? 0.6 : 0.8)
            let penguinHeight = geometry.size.height * (isCompact ? 0.57 : 0.65)
            let unavailablePenguinWidth = geometry.size.width * (isCompact ? 0.08 : 0.1)
            let unavailablePenguinXPositions = isCompact ? [0.28, 0.71] : [0.22, 0.77]
            let unavailablePenguinYPosition = geometry.size.height * (isCompact ? 0.59 : 0.68)
            
            ZStack {
                Group {
                    //MARK: Background
                    Image("Q1_iPhoneBackground")
                        .resizable()
                        .frame(width: geometry.size.width * backgroundScale,
                               height: geometry.size.height * backgroundScale)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    ///MARK:HomeButton
                    if isCompact {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                                .position(x: geometry.size.width * 0.01, y: geometry.size.height * 0.13)
                        }
                    } else {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
                                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
                        }
                    }
                    
                    ///Problem String
                    HStack {
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                Text("3 - 5 = 2")
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 0)
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)
                    
                    
                    
                    ///MARK: Bottom Background iPhone
                    HStack {
                        FlippyRiveView(riveInput: $riveInput)
                            .frame(width: geometry.size.width * 0.25)
                            .position(x: geometry.size.width * 0.02, y: geometry.size.height * 0.92)
                        
                        ZStack(alignment: .leading) {
                            Image("MessagePlaceholder")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.25)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                            
                            Text("Namun, sayangnya ada 2 temanku yang tidak bisa hadir.")
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                .lineLimit(nil)
                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                        }
                        
                        Button(action: {
                        }, label: {
                            Image("CorrectButton")
                                .resizable()
                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                        })
                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.97)
                    }
                }
                
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
    }
}

//#Preview {

//    Question1View()
//}

struct Question2View: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var currentMessageIndex = 1
    
    var isCompact: Bool {
        verticalSizeClass == .compact
    }
    
    // Constants
    let backgroundScale: CGFloat = 1.2
    
    ///MARK: Bottom View
    @State var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    
    var body: some View {
        ///Problem String
        GeometryReader { geometry in
            ZStack {
                Group {
                    //MARK: Background
                    Image("Q2_iPhoneBackground")
                        .resizable()
                        .frame(width: geometry.size.width * backgroundScale,
                               height: geometry.size.height * backgroundScale)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    ///MARK:HomeButton
                    if isCompact {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                                .position(x: geometry.size.width * 0.01, y: geometry.size.height * 0.13)
                        }
                    } else {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
                                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.1)
                        }
                    }
                    
                    ///Problem String
                    HStack {
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                Text("3 - 5 = 2")
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 0)
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)
                    
                    
                    
                    ///MARK: Bottom Background iPhone
                    HStack {
                        FlippyRiveView(riveInput: $riveInput)
                            .frame(width: geometry.size.width * 0.25)
                            .position(x: geometry.size.width * 0.02, y: geometry.size.height * 0.92)
                        
                        ZStack(alignment: .leading) {
                            Image("MessagePlaceholder")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.25)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                            
                            Text("Namun, sayangnya ada 2 temanku yang tidak bisa hadir.")
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                .lineLimit(nil)
                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                        }
                        
                        Button(action: {
                        }, label: {
                            Image("CorrectButton")
                                .resizable()
                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                        })
                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.97)
                    }
                }
                
                ///Children
                //Constants
                let imageWidth: CGFloat = isCompact ? geometry.size.width * 0.23 : geometry.size.width * 0.30
                let tableWidth: CGFloat = isCompact ? geometry.size.width * 0.35 : geometry.size.width * 0.45
                let imagePositionX: CGFloat = isCompact ? geometry.size.width * 0.235 : geometry.size.width / 5.5
                let imagePositionY: CGFloat = isCompact ? geometry.size.height * 0.46 : geometry.size.height * 0.442
                let tablePositionX: CGFloat = isCompact ? geometry.size.width * 0.23 : geometry.size.width * 0.175
                let tablePositionY: CGFloat = isCompact ? geometry.size.height * 0.13 : geometry.size.height * 0.1
                let penguinFrameWidth: CGFloat = isCompact ? geometry.size.width * 0.6 : geometry.size.width * 0.8
                let penguinPositionY: CGFloat = isCompact ? geometry.size.height * 0.58 : geometry.size.height * 0.65
                
                HStack {
                    VStack {
                        Image(currentMessageIndex > 1 ? "" : "Q2_Hats")
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
                    
                    (currentMessageIndex > 1 ? AnyView(PenguinsHatView()) : AnyView(PenguinsView()))
                        .frame(width: penguinFrameWidth)
                        .position(x: geometry.size.width / 5.5, y: penguinPositionY)
                }
                
                
            }
        }
    }
}

#Preview(body: {
    Question2View()
})

struct Question3View: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var currentMessageIndex = 3
    var isCompact: Bool {
        verticalSizeClass == .compact
    }
    let backgroundScale: CGFloat = 1.2
    @State var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    //MARK: Background
                    Image("Q2_iPhoneBackground")
                        .resizable()
                        .frame(width: geometry.size.width * backgroundScale,
                               height: geometry.size.height * backgroundScale)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    ///MARK:HomeButton
                    if isCompact {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                                .position(x: geometry.size.width * 0.01, y: geometry.size.height * 0.13)
                        }
                    } else {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
                                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
                        }
                    }
                    
                    ///Problem String
                    HStack {
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                Text("3 - 5 = 2")
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 0)
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.25)
                    
                    
                    
                    ///MARK: Bottom Background iPhone
                    HStack {
                        FlippyRiveView(riveInput: $riveInput)
                            .frame(width: geometry.size.width * 0.25)
                            .position(x: geometry.size.width * 0.02, y: geometry.size.height * 0.92)
                        
                        ZStack(alignment: .leading) {
                            Image("MessagePlaceholder")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.25)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                            
                            Text("Namun, sayangnya ada 2 temanku yang tidak bisa hadir.")
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                .lineLimit(nil)
                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                        }
                        
                        Button(action: {
                        }, label: {
                            Image("CorrectButton")
                                .resizable()
                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                        })
                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.97)
                    }
                }
                
                ///Children
                if isCompact {
                    VStack {
                        switch currentMessageIndex {
                        case ..<2:
                            IdleBalloonView()
                        case 2:
                            FlyingBalloonView()
                        default:
                            IdleBalloon2View()
                        }
                    }
                } else {
                    VStack {
                        switch currentMessageIndex {
                        case ..<2:
                            IdleBalloonView()
                        case 2:
                            FlyingBalloonView()
                        default:
                            IdleBalloon2View()
                        }
                    }
                }
            }
        }
    }
}

//#Preview(body: {
//    Question3View()
//})

struct Question4View: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var currentMessageIndex = 0
    var isCompact: Bool {
        verticalSizeClass == .compact
    }
    let backgroundScale: CGFloat = 1.2
    @State var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    //MARK: Background
                    Image("Q4_iPhoneBackground")
                        .resizable()
                        .frame(width: geometry.size.width * backgroundScale,
                               height: geometry.size.height * backgroundScale)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    ///MARK:HomeButton
                    if isCompact {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                                .position(x: geometry.size.width * 0.01, y: geometry.size.height * 0.13)
                        }
                    } else {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
                                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
                        }
                    }
                    
                    ///Problem String
                    HStack {
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                Text("3 - 5 = 2")
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 0)
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)
                    
                    
                    
                    ///MARK: Bottom Background iPhone
                    HStack {
                        FlippyRiveView(riveInput: $riveInput)
                            .frame(width: geometry.size.width * 0.25)
                            .position(x: geometry.size.width * 0.02, y: geometry.size.height * 0.92)
                        
                        ZStack(alignment: .leading) {
                            Image("MessagePlaceholder")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.25)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                            
                            Text("Namun, sayangnya ada 2 temanku yang tidak bisa hadir.")
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                .lineLimit(nil)
                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                        }
                        
                        Button(action: {
                        }, label: {
                            Image("CorrectButton")
                                .resizable()
                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                        })
                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.97)
                    }
                }
                
                ///Children
                let isInitialMessage = currentMessageIndex < 1
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
        }
    }
}

//#Preview(body: {
//    Question4View()
//})

struct Question5View: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var currentMessageIndex = 4
    var isCompact: Bool {
        verticalSizeClass == .compact
    }
    let backgroundScale: CGFloat = 1.2
    @State var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    
    
    /// MARK: SOAL NOMOR 5: Cakes & Flies
    @State var flyPositions: [(x: CGFloat, y: CGFloat)] = [
        (x: 0.1, y: 0.6),
        (x: 0.16, y: 0.3),
        (x: 0.2, y: 0.7),
        (x: 0.3, y: 0.25),
        (x: 0.5, y: 0.45),
        (x: 0.45, y: 0.71),
        (x: 0.8, y: 0.7),
        (x: 0.75, y: 0.3),
        (x: 0.9, y: 0.5)
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
                Group {
                    //MARK: Background
                    Image("Q4_iPhoneBackground")
                        .resizable()
                        .frame(width: geometry.size.width * backgroundScale,
                               height: geometry.size.height * backgroundScale)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    ///MARK:HomeButton
                    if isCompact {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                                .position(x: geometry.size.width * 0.01, y: geometry.size.height * 0.13)
                        }
                    } else {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
                                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
                        }
                    }
                    
                    ///Problem String
                    HStack {
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                Text("?")
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 0)
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)
                    
                    
                    
                    ///MARK: Bottom Background iPhone
                    HStack {
                        FlippyRiveView(riveInput: $riveInput)
                            .frame(width: geometry.size.width * 0.25)
                            .position(x: geometry.size.width * 0.02, y: geometry.size.height * 0.92)
                        
                        ZStack(alignment: .leading) {
                            Image("MessagePlaceholder")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.25)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                            
                            Text("Namun, sayangnya ada 2 temanku yang tidak bisa hadir.")
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                .lineLimit(nil)
                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                        }
                        
                        Button(action: {
                        }, label: {
                            Image("CorrectButton")
                                .resizable()
                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                        })
                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.97)
                    }
                }
                
                ///Children
                if isCompact {
                    ZStack {
                        Image("Q5_2Cakes")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.4)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.55)
                        
                        ForEach(0..<flyCount, id: \.self) { index in
                            Image("Q5_Fly\(index + 1)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.045)
                                .position(x: flyPosition(for: index, geometry: geometry).x,
                                          y: flyPosition(for: index, geometry: geometry).y)
                                .onAppear {
                                    flyAnimation(for: index, geometry: geometry)
                                }
                        }
                    }
                } else {
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
                                .position(x: flyPosition(for: index, geometry: geometry).x,
                                          y: flyPosition(for: index, geometry: geometry).y)
                                .onAppear {
                                    flyAnimation(for: index, geometry: geometry)
                                }
                        }
                    }
                }
            }
        }
    }
}

//#Preview(body: {
//    Question5View()
//})

struct Question6View: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var currentMessageIndex = 3
    var isCompact: Bool {
        verticalSizeClass == .compact
    }
    let backgroundScale: CGFloat = 1.2
    @State var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    
    @State var isPlaying: Bool = false
    @State var babyFoxPositions: [(x: CGFloat, y: CGFloat)] = [
        (x: 0.456, y: 0.64),
        (x: 0.568, y: 0.66),
        (x: 0.202, y: 0.60),
        (x: 0.105, y: 0.64),
        (x: 0.78, y: 0.65),
        (x: 0.89, y: 0.6)
    ]
    
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
                Group {
                    //MARK: Background
                    Image("Q6_iPhoneBackground")
                        .resizable()
                        .frame(width: geometry.size.width * backgroundScale,
                               height: geometry.size.height * backgroundScale)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    ///MARK:HomeButton
                    if isCompact {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                                .position(x: geometry.size.width * 0.01, y: geometry.size.height * 0.13)
                        }
                    } else {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
                                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
                        }
                    }
                    
                    ///Problem String
                    HStack {
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                Text(" 4 + 4 + 2 = 8")
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 0)
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)
                    
                    
                    
                    ///MARK: Bottom Background iPhone
                    HStack {
                        FlippyRiveView(riveInput: $riveInput)
                            .frame(width: geometry.size.width * 0.25)
                            .position(x: geometry.size.width * 0.02, y: geometry.size.height * 0.92)
                        
                        ZStack(alignment: .leading) {
                            Image("MessagePlaceholder")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.25)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                            
                            Text("Namun, sayangnya ada 2 temanku yang tidak bisa hadir.")
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                .lineLimit(nil)
                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                        }
                        
                        Button(action: {
                        }, label: {
                            Image("CorrectButton")
                                .resizable()
                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                        })
                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.97)
                    }
                }
                
                if isCompact {
                    ZStack {
                        HStack {
                            ArcticFoxView(isPlay: $isPlaying)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.35)
                                .position(x: geometry.size.width / 3, y: geometry.size.height * 0.53)
                                .onTapGesture {
                                    isPlaying.toggle()
                                }
                            
                            ArcticFoxView(isPlay: $isPlaying)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.35)
                                .position(x: geometry.size.width / 6, y: geometry.size.height * 0.55)
                                .onTapGesture {
                                    isPlaying.toggle()
                                }
                        }
                        
                        ForEach(0..<foxCount, id: \.self) { index in
                            BabyFoxView(isPlay: $isPlaying)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.4)
                                .position(x: babyFoxPosition(for: index, geometry: geometry).x,
                                          y: babyFoxPosition(for: index, geometry: geometry).y)
                                .onTapGesture {
                                    isPlaying.toggle()
                                }
                        }
                    }
                } else {
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
                                .frame(width: geometry.size.width * 0.1)
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
    }
}

//#Preview(body: {
//    Question6View()
//})

struct Question7View: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var currentMessageIndex = 4
    var isCompact: Bool {
        verticalSizeClass == .compact
    }
    let backgroundScale: CGFloat = 1.2
    @State var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    
    
    @State var tapCount = 0
    @State var isTapped = false
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    //MARK: Background
                    Image("Q7_Background")
                        .resizable()
                        .frame(width: geometry.size.width * backgroundScale,
                               height: geometry.size.height * backgroundScale)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    ///MARK:HomeButton
                    if isCompact {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                                .position(x: geometry.size.width * 0.01, y: geometry.size.height * 0.13)
                        }
                    } else {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
                                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
                        }
                    }
                    
                    ///Problem String
                    HStack {
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                Text(" 4 + 4 + 2 = 8")
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 0)
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)
                    
                    
                    
                    ///MARK: Bottom Background iPhone
                    HStack {
                        FlippyRiveView(riveInput: $riveInput)
                            .frame(width: geometry.size.width * 0.25)
                            .position(x: geometry.size.width * 0.02, y: geometry.size.height * 0.92)
                        
                        ZStack(alignment: .leading) {
                            Image("MessagePlaceholder")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.25)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                            
                            Text("Namun, sayangnya ada 2 temanku yang tidak bisa hadir.")
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                .lineLimit(nil)
                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                        }
                        
                        Button(action: {
                        }, label: {
                            Image("CorrectButton")
                                .resizable()
                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                        })
                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.97)
                    }
                }
                
                ///Children
                if isCompact {
                    ZStack {
                        if currentMessageIndex < 3 {
                            Image("Q7_iPhonePinataRope")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 1.2)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.26)
                        }
                        
                        if currentMessageIndex < 2 {
                            Image("Q7_Pinata")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.25)
                                .position(x: geometry.size.width * 0.502, y: geometry.size.height * 0.45)
                                .scaleEffect(isTapped ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: isTapped)
                                .rotationEffect(.degrees(-10))
                            
                            
                            if currentMessageIndex == 1 {
                                Text("Tekan 5x untuk memecahkan pinata!")
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 16))
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                                    .fontWeight(.bold)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                            }
                            
                            
                        } else if currentMessageIndex < 3 {
                            PinataView()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.45)
                                .position(x: geometry.size.width * 0.505, y: geometry.size.height * 0.45)
                        } else if currentMessageIndex < 4 {
                            Image("Q7_20Candies")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.7)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.64)
                        } else {
                            Image("Q7_15Candies")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.5)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.62)
                        }
                    }
                } else {
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
                            
                            
                            if currentMessageIndex == 1 {
                                Text("Tekan 5x untuk memecahkan pinata!")
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 48))
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                                    .fontWeight(.bold)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.85)
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
        }
    }
}

//#Preview(body: {
//    Question7View()
//})

struct Question8View: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var currentMessageIndex = 3
    var isCompact: Bool {
        verticalSizeClass == .compact
    }
    let backgroundScale: CGFloat = 1.2
    @State var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    //MARK: Background
                    Image("Q7_iPhoneBackground")
                        .resizable()
                        .frame(width: geometry.size.width * backgroundScale,
                               height: geometry.size.height * backgroundScale)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    ///MARK:HomeButton
                    if isCompact {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                                .position(x: geometry.size.width * 0.01, y: geometry.size.height * 0.13)
                        }
                    } else {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
                                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
                        }
                    }
                    
                    ///Problem String
                    HStack {
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                Text(" 4 + 4 + 2 = 8")
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 0)
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)
                    
                    
                    
                    ///MARK: Bottom Background iPhone
                    HStack {
                        FlippyRiveView(riveInput: $riveInput)
                            .frame(width: geometry.size.width * 0.25)
                            .position(x: geometry.size.width * 0.02, y: geometry.size.height * 0.92)
                        
                        ZStack(alignment: .leading) {
                            Image("MessagePlaceholder")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.25)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                            
                            Text("Namun, sayangnya ada 2 temanku yang tidak bisa hadir.")
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                .lineLimit(nil)
                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                        }
                        
                        Button(action: {
                        }, label: {
                            Image("CorrectButton")
                                .resizable()
                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                        })
                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.97)
                    }
                }
                
                /// Children
                if isCompact {
                    if currentMessageIndex < 2 {
                        PolarBearView(key: "isOpen", value: false)
                            .frame(width: geometry.size.width * 0.5)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.45)
                    } else {
                        PolarBearView(key: "isOpen", value: true)
                            .frame(width: geometry.size.width * 0.38)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.55)
                    }
                } else {
                    if currentMessageIndex < 2 {
                        PolarBearView(key: "isOpen", value: false)
                            .frame(width: geometry.size.width * 0.7)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.55)
                    } else {
                        PolarBearView(key: "isOpen", value: true)
                            .frame(width: geometry.size.width * 0.6)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                    }
                }
                
            }
        }
    }
}

//#Preview(body: {
//    Question8View()
//})

struct OutroView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var currentMessageIndex = 2
    var isCompact: Bool {
        verticalSizeClass == .compact
    }
    let backgroundScale: CGFloat = 1.2
    @State var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
    
    
    /// MARK: SOAL NOMOR 9: Outro
    @State var rotation: Double = 0
    @State var scale: CGFloat = 0.5
    @State var isTapped = false
    @State var tapCount = 0
    
    
    ///MARK: SHARED
    func handleTap(tapThreshold: Int? = nil, tapDelay: Double = 0.5, upperLimit: Int = 2) {
        isTapped = true
        
        if let threshold = tapThreshold {
            tapCount += 1
            if tapCount >= threshold {
                tapCount = 0
                moveToNextMessage(upperLimit: upperLimit)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + tapDelay) {
            self.isTapped = false
            if tapThreshold == nil {
                self.moveToNextMessage(upperLimit: upperLimit)
            }
        }
    }
    
    private func moveToNextMessage(upperLimit: Int) {
        if currentMessageIndex < upperLimit {
            currentMessageIndex += 1
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    //MARK: Background
                    Image("Q7_iPhoneBackground")
                        .resizable()
                        .frame(width: geometry.size.width * backgroundScale,
                               height: geometry.size.height * backgroundScale)
                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
                    ///MARK:HomeButton
                    if isCompact {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
                                .position(x: geometry.size.width * 0.01, y: geometry.size.height * 0.13)
                        }
                    } else {
                        Button {
                        } label: {
                            Image("HomeButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
                                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
                        }
                    }
                    
                    ///Problem String
                    HStack {
                        ZStack(alignment: .topLeading) {
                            VStack(spacing: 0) {
                                Text(" 4 + 4 + 2 = 8")
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 16)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 0)
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.9)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)
                    
                    
                    
                    ///MARK: Bottom Background iPhone
                    HStack {
                        FlippyRiveView(riveInput: $riveInput)
                            .frame(width: geometry.size.width * 0.25)
                            .position(x: geometry.size.width * 0.02, y: geometry.size.height * 0.92)
                        
                        ZStack(alignment: .leading) {
                            Image("MessagePlaceholder")
                                .resizable()
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.25)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                            
                            Text("Namun, sayangnya ada 2 temanku yang tidak bisa hadir.")
                                .font(.custom("PilcrowRoundedVariable-Regular", size: 24))
                                .fontWeight(.bold)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                .lineLimit(nil)
                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
                        }
                        
                        Button(action: {
                        }, label: {
                            Image("CorrectButton")
                                .resizable()
                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
                        })
                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.97)
                    }
                }
            }
            /// Children
            if isCompact {
                ZStack {
                    //                        Image("Outro_iPhoneBackground")
                    //                            .resizable()
                    //                            .scaledToFill()
                    //                            .ignoresSafeArea()
                    
                    if currentMessageIndex < 2 || currentMessageIndex == 4 {
                        Image("Outro_HBD_Banner")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.65)
                            .position(x: geometry.size.width / 2, y: geometry.size.width * 0.065)
                        
                        IdleBalloonView()
                        
                        ArcticFoxView(isPlay: .constant(true))
                            .frame(width: geometry.size.width * 0.4)
                            .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.55)
                        
                        BabyFoxView(isPlay: .constant(true))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.4)
                            .position(x: geometry.size.width * 0.72, y: geometry.size.height * 0.7)
                        
                        PenguinsView()
                            .frame(width: geometry.size.width * 0.6)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                        
                        PolarBearOnlyView()
                            .frame(width: geometry.size.width * 0.4)
                            .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.55)
                        
                    } else if currentMessageIndex == 2 {
                        Image("Outro_Gift")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.33)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.4)
                            .scaleEffect(isTapped ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.4), value: isTapped)
                            .onTapGesture {
                                if currentMessageIndex == 2 {
                                    handleTap(tapDelay: 0.5, upperLimit: 3)
                                }
                            }
                        
                        Text("Tekan Hadiah untuk membuka!")
                            .font(.custom("PilcrowRoundedVariable-Regular", size: 16))
                            .foregroundStyle(.black)
                            .opacity(0.5)
                            .fontWeight(.bold)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.76)
                        
                    } else if currentMessageIndex == 3 {
                        Group {
                            Image("Outro_Starburst")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.27)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
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
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.4)
                    }
                }
            } else {
                //                    ZStack {
                //                        Image("Outro_Background")
                //                            .resizable()
                //                            .scaledToFill()
                //                            .ignoresSafeArea()
                //
                //                        if viewModel.currentMessageIndex < 2 || viewModel.currentMessageIndex == 4 {
                //                            Image("Outro_HBD_Banner")
                //                                .resizable()
                //                                .aspectRatio(contentMode: .fit)
                //                                .frame(width: geometry.size.width * 0.65)
                //                                .position(x: geometry.size.width / 2, y: geometry.size.width * 0.065)
                //
                //                            IdleBalloonView()
                //
                //                            ArcticFoxView(isPlay: .constant(true))
                //                                .frame(width: geometry.size.width * 0.45)
                //                                .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.64)
                //
                //                            BabyFoxView(isPlay: .constant(true))
                //                                .aspectRatio(contentMode: .fit)
                //                                .frame(width: geometry.size.width * 0.5)
                //                                .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.75)
                //
                //                            PenguinsView()
                //                                .frame(width: geometry.size.width * 0.85)
                //                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.64)
                //
                //                            PolarBearOnlyView()
                //                                .frame(width: geometry.size.width * 0.6)
                //                                .position(x: geometry.size.width * 0.14, y: geometry.size.height * 0.62)
                //
                //                        } else if viewModel.currentMessageIndex == 2 {
                //                            Image("Outro_Gift")
                //                                .resizable()
                //                                .aspectRatio(contentMode: .fit)
                //                                .frame(width: geometry.size.width * 0.45)
                //                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.45)
                //                                .scaleEffect(viewModel.isTapped ? 1.2 : 1.0)
                //                                .animation(.easeInOut(duration: 0.4), value: viewModel.isTapped)
                //                                .onTapGesture {
                //                                    if viewModel.currentMessageIndex == 2 {
                //                                        viewModel.handleTap(tapDelay: 0.5, upperLimit: 3)
                //                                    }
                //                                }
                //
                //                            Text("Tekan Hadiah untuk membuka!")
                //                                .font(.custom("PilcrowRoundedVariable-Regular", size: 48))
                //                                .foregroundStyle(.black)
                //                                .opacity(0.5)
                //                                .fontWeight(.bold)
                //                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.85)
                //
                //                        } else if viewModel.currentMessageIndex == 3 {
                //                            Group {
                //                                Image("Outro_Starburst")
                //                                    .resizable()
                //                                    .aspectRatio(contentMode: .fit)
                //                                    .frame(width: geometry.size.width * 0.7)
                //                                    .rotationEffect(.degrees(viewModel.rotation))
                //                                    .scaleEffect(viewModel.scale)
                //                            }
                //                            .onAppear {
                //                                withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
                //                                    viewModel.rotation = 360
                //                                }
                //                                withAnimation(Animation.easeInOut(duration: 2)) {
                //                                    viewModel.scale = 1.5
                //                                }
                //                            }
                //
                //                            RewardAnimationView()
                //                                .aspectRatio(contentMode: .fit)
                //                                .frame(width: geometry.size.width * 0.65)
                //                        }
                //                    }
            }
            
        }
    }
}

//#Preview(body: {
//    OutroView()
//})

//struct IntroView: View {
//
//    @Environment(\.verticalSizeClass) var verticalSizeClass
//
//    var isCompact: Bool {
//        verticalSizeClass == .compact
//    }
//
//    // Constants
//    let backgroundScale: CGFloat = 1.2
//
//    ///MARK: Bottom View
//    @State var riveInput: [FlippyRiveInput] = [FlippyRiveInput(key: .talking, value: FlippyValue.float(2.0))]
//
//    var body: some View {
//        GeometryReader { geometry in
//            // Constants
//            let penguinWidth = geometry.size.width * (isCompact ? 0.6 : 0.8)
//            let penguinHeight = geometry.size.height * (isCompact ? 0.57 : 0.65)
//            let unavailablePenguinWidth = geometry.size.width * (isCompact ? 0.08 : 0.1)
//            let unavailablePenguinXPositions = isCompact ? [0.28, 0.71] : [0.22, 0.77]
//            let unavailablePenguinYPosition = geometry.size.height * (isCompact ? 0.59 : 0.68)
//
//            ZStack {
//                Group {
//                    //MARK: Background
//                    Image("Q1_iPhoneBackground")
//                        .resizable()
//                        .frame(width: geometry.size.width * backgroundScale,
//                               height: geometry.size.height * backgroundScale)
//                        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
//
//                    ///MARK:HomeButton
//                    if isCompact {
//                        Button {
//                        } label: {
//                            Image("HomeButton")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2)
//                                .position(x: geometry.size.width * 0.01, y: geometry.size.height * 0.13)
//                        }
//                    } else {
//                        Button {
//                        } label: {
//                            Image("HomeButton")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15)
//                                .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
//                        }
//                    }
//
//                    ///Problem String
//                    HStack {
//                        ZStack(alignment: .topLeading) {
//                            VStack(spacing: 0) {
//                                Text("3 - 5 = 2")
//                                    .font(.custom("PilcrowRoundedVariable-Regular", size: 96))
//                                    .fontWeight(.heavy)
//                                    .foregroundColor(.white)
//                                    .multilineTextAlignment(.center)
//                                    .padding(.top, 16)
//                                    .padding(.horizontal, 16)
//                                    .padding(.bottom, 0)
//                            }
//                        }
//                    }
//                    .frame(width: geometry.size.width * 0.9)
//                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)
//
//
//
//                    ///MARK: Bottom Background iPhone
//                    HStack {
//                        FlippyRiveView(riveInput: $riveInput)
//                            .frame(width: geometry.size.width * 0.25)
//                            .position(x: geometry.size.width * 0.02, y: geometry.size.height * 0.92)
//
//                        ZStack(alignment: .leading) {
//                            Image("MessagePlaceholder")
//                                .resizable()
//                                .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.25)
//                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
//
//                            Text("Namun, sayangnya ada 2 temanku yang tidak bisa hadir.")
//                                .font(.custom("PilcrowRoundedVariable-Regular", size: 24))
//                                .fontWeight(.bold)
//                                .padding(.leading, 20)
//                                .padding(.bottom, 10)
//                                .lineLimit(nil)
//                                .frame(width: geometry.size.width * 0.7, alignment: .leading)
//                                .multilineTextAlignment(.leading)
//                                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.92)
//                        }
//
//                        Button(action: {
//                        }, label: {
//                            Image("CorrectButton")
//                                .resizable()
//                                .frame(width: geometry.size.width * 0.17, height: geometry.size.width * 0.1)
//                        })
//                        .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.97)
//                    }
//                }
//
//                PenguinsView()
//                    .frame(width: penguinWidth)
//                    .position(x: geometry.size.width / 2, y: penguinHeight)
//
//                ForEach(0..<unavailablePenguinXPositions.count) { index in
//                    Image("Q1_UnavailablePenguin")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: unavailablePenguinWidth)
//                        .position(x: geometry.size.width * unavailablePenguinXPositions[index],
//                                  y: unavailablePenguinYPosition)
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    IntroView()
//}
