//
//  CreditView.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 22/08/24.
//

import Foundation
import SwiftUI
import Routing

struct CreditsView: View {
    @State private var animate = false
    @State private var showNextView = false
    @State private var showTextCredit = false
    @State var riveInput: [FlippyRiveInput] = []
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @EnvironmentObject private var router: Router<NavigationRoute>
    
    var audioHelper : AudioHelper = AudioHelper.shared
    
    var body: some View {
        
        GeometryReader{ geometry in
            ZStack {
                Image("BgCredit")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 1.2, height: geometry.size.height)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.5)
                
                ZStack {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(credits, id: \.self) { credit in
                                Text(credit)
                                    .font(.custom("PilcrowRoundedVariable-Regular", size: verticalSizeClass == .compact ? 38 : 52))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                
                            }
                            Spacer()
                                .frame(height: geometry.size.height / 2) // Ruang kosong untuk logo
                        }
                        .offset(y: animate ? -geometry.size.height : geometry.size.height)
                    }
                    .allowsHitTesting(false)
                    
                    if showTextCredit {
                        Image("Logo")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                    }
                    
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.5)
                .onAppear {
                    if let audioTime = audioHelper.getAudioDuration(named: "Snowflake Birthday", fileType: "wav") {
                        
                        
                        let dispatchTime = DispatchTime.now() + audioTime
                        
                        
                        withAnimation(.linear(duration: audioTime + 5)) {
                            animate = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                            withAnimation {
                                showTextCredit = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                
                                showNextView = true
                                
                            }
                            
                            
                        }
                    } else {
                        // Handle the case where the duration couldn't be retrieved
                        print("Failed to get audio duration.")
                    }
                    
                }
                
                
                
                Image("BgCreditLand")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 1.2, height: geometry.size.height)
                    .position(x: geometry.size.width / 2, y: geometry.size.height )
                
                
                
                PenguinsView()
                    .frame(width: verticalSizeClass == .compact ? geometry.size.width * 0.3 : geometry.size.width * 0.4, height: geometry.size.height * 0.4 )
                    .position(x:geometry.size.width * 0.12, y: geometry.size.height  * 0.9)
                
                FlippyRiveView(riveInput: $riveInput)
                    .frame(width: geometry.size.width * 0.17, height: geometry.size.height * 0.17 )
                    .position(x: verticalSizeClass == .compact ? geometry.size.width * 0.81 : geometry.size.width * 0.77, y: geometry.size.height  * 0.915)
                
                ArcticFoxView(isPlay: .constant(true))
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.2 )
                    .position(x:geometry.size.width * 0.95, y: geometry.size.height  * 0.92)
                
                BabyFoxView(isPlay: .constant(true))
                    .frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.22 )
                    .position(x:geometry.size.width * 0.91, y: geometry.size.height  * 0.97)
                
                PolarBearOnlyView()
                    .frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.25 )
                    .position(x:verticalSizeClass == .compact ? geometry.size.width * 0.86 : geometry.size.width * 0.84, y: geometry.size.height  * 0.89)
                    .onLongPressGesture {
                        showNextView = true
                    }
                
                SwingingPinataView()
                    .frame(width: verticalSizeClass == .compact ? geometry.size.width * 0.4 : geometry.size.width * 0.25, height: verticalSizeClass == .compact ? geometry.size.height * 0.4 : geometry.size.height * 0.25 )
                    .position(x:geometry.size.width * 0.06, y: verticalSizeClass == .compact ? geometry.size.height * 0.2 : geometry.size.height  * 0.1)
                
                IdleBalloonView()
                    .frame(width:verticalSizeClass == .compact ? geometry.size.width * 0.7 :  geometry.size.width * 0.4, height:verticalSizeClass == .compact ? geometry.size.height * 0.7: geometry.size.height * 0.4 )
                    .position(x:geometry.size.width * 1.02, y: verticalSizeClass == .compact ? geometry.size.height * 0.35: geometry.size.height  * 0.2)
                
            }
            .onAppear(){
                audioHelper.stopMusicQuestion()
                audioHelper.playSoundEffect(named: "Snowflake Birthday", fileType: "wav")
                
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    withAnimation{
                        riveInput = [
                            FlippyRiveInput(key: .talking, value: FlippyValue.float(0.0)),
                            FlippyRiveInput(key: .isSad, value: .bool(false)),
                            FlippyRiveInput(key: .isRightHandsUp, value: .bool(false)),
                            FlippyRiveInput(key: .isLeftHandsUp, value: .bool(true))
                        ]
                    }
                }
                
                Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { _ in
                    withAnimation {
                        riveInput = [
                            FlippyRiveInput(key: .talking, value: FlippyValue.float(0.0)),
                            FlippyRiveInput(key: .isSad, value: .bool(false)),
                            FlippyRiveInput(key: .isRightHandsUp, value: .bool(false)),
                            FlippyRiveInput(key: .isLeftHandsUp, value: .bool(false))
                        ]
                    }
                    
                    
                }
                
                
            }
            .onChange(of: showNextView) { _ , _  in
                if showNextView{
                    router.navigateToRoot()
                    audioHelper.stopSoundEffect()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
    func calculateLogoOffset(geometry: GeometryProxy) -> CGFloat {
        let logoPosition = geometry.size.height / 2
        let logoHeight: CGFloat = 100 // Tinggi logo
        let offset = max(-geometry.size.height, logoPosition - logoHeight / 2)
        return offset
    }
    
    let credits = [
        "Flippy Math",
        "By Childhood",
        "",
        "Ayatullah Ma'arif",
        "Enrico Olivian Maricar",
        "Muh. Fathin Abdillah",
        "Rajesh Triadi Noftarizal",
        "William Jonathan Handoko",
        "",
        "",
        ""
    ]
}


#Preview {
    CreditsView()
        .previewInterfaceOrientation(.landscapeLeft)
}
