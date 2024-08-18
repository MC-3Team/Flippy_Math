//
//  PinataView.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 18/08/24.
//

import SwiftUI
import RiveRuntime

struct PinataView: View {
    @StateObject var riveVM = RiveViewModel(fileName: "pinata", stateMachineName: "Crack")
    
    var isCrack: Bool
    
    var body: some View {
        VStack{
            riveVM.view()
                .ignoresSafeArea()
              
        }
        .onAppear(){
            riveVM.setInput("isCrack", value: isCrack)
        }
    }
}
struct IdlePinataView: View {
    @StateObject var riveVM = RiveViewModel(fileName: "pinata", stateMachineName: "State Machine 1")
    var body: some View {
        riveVM.view()
            .ignoresSafeArea()
    }
}

#Preview {
    PinataView(isCrack: false)
}

#Preview {
    IdlePinataView()
}

