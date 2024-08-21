//
//  PolarBearView.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 18/08/24.
//

import SwiftUI
import RiveRuntime

struct PolarBearView: View {
    
    @StateObject var riveVM = RiveViewModel(fileName: "polarbear", stateMachineName: "State Machine 1")
    
    var key: String
    var value: Bool
    
    var body: some View {
        riveVM.view()
            .onAppear() {
                if key == "bearOnly"{
                    riveVM.stop()
                }
                riveVM.setInput(key, value: value)
                
            }
    }
}

struct PolarBearOnlyView: View {
    
    @StateObject var riveVM = RiveViewModel(fileName: "polarbear", stateMachineName: "State Machine 2")
    
    var body: some View {
        riveVM.view()
    }
}

#Preview {
    TestView()
}

struct TestView: View {
    @State var isOpen = true
    var body: some View {
        PolarBearView(key: "bearOnly", value: true)
    }
}

#Preview {
    PolarBearOnlyView()
}
