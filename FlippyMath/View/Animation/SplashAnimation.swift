//
//  SplashAnimation.swift
//  FlippyMath
//
//  Created by Rajesh Triadi Noftarizal on 21/08/24.
//

import SwiftUI
import RiveRuntime

struct SplashAnimation: View {
    
    @StateObject var riveVM = RiveViewModel(fileName: "splash")
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                if verticalSizeClass == .compact{
                    Image("BgSplashPhone")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    riveVM.view()
                        .position(x: geo.size.width / 2, y: geo.size.height * 0.55)
                }
                else{
                    Image("BgSplashPad")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    riveVM.view()
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.9)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    
                }
            }
        }
    }
}

#Preview {
    SplashAnimation()
}
