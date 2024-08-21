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

    var body: some View {
        riveVM.view()
            .ignoresSafeArea()
    }
}

#Preview {
    SplashAnimation()
}
