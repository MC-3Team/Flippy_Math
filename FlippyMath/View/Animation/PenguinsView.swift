//
//  PenguinsView.swift
//  FlippyMath
//
//  Created by Rajesh Triadi Noftarizal on 21/08/24.
//

import SwiftUI
import RiveRuntime

struct PenguinsView: View {
    
    @StateObject var riveVM = RiveViewModel(fileName: "penguins", stateMachineName: "Idle")

    var body: some View {
        riveVM.view()
    }
}
struct PenguinsHomeView: View {
    
    @StateObject var riveVM = RiveViewModel(fileName: "penguins", stateMachineName: "Boyband")

    var body: some View {
        riveVM.view()
    }
}
#Preview {
    PenguinsView()
}
#Preview {
    PenguinsHomeView()
}
