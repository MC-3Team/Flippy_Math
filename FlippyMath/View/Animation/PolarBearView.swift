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
    
    var isOpen: Bool
    
    var body: some View {
        riveVM.view()
            .onAppear() {
                riveVM.setInput("isOpen", value: isOpen)
            }
    }
}

#Preview {
    TestView()
}

struct TestView: View {
    @State var isOpen = true
    var body: some View {
        PolarBearView(isOpen: false)
         
        
  
    }
}
