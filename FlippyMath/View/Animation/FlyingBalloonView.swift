//
//  FlyingBalloonView.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 18/08/24.
//

import SwiftUI
import RiveRuntime

struct FlyingBalloonView: View {
    @StateObject var riveVM = RiveViewModel(fileName: "flyingballoon", stateMachineName: "Flying Balloon")

    var body: some View {
        riveVM.view()
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

struct IdleBalloonView: View {
    @StateObject var riveVM = RiveViewModel(fileName: "flyingballoon", stateMachineName: "Idle")
    
    var body: some View {
        riveVM.view()
            .ignoresSafeArea()
            .allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)

    }
}

struct IdleBalloon2View: View {
    @StateObject var riveVM = RiveViewModel(fileName: "flyingballoon", stateMachineName: "Idle After")
    
    var body: some View {
        riveVM.view()
            .ignoresSafeArea()
            .allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)

    }
}


#Preview {
    IdleBalloonView()
}
#Preview {
    FlyingBalloonView()
}

#Preview {
    IdleBalloon2View()
}

