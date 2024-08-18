//
//  ArcticFoxView.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 18/08/24.
//

import SwiftUI
import RiveRuntime

struct ArcticFoxView: View {
    @StateObject var riveVM =    RiveViewModel(fileName: "arcticfox", stateMachineName: "Big Fox")

    var body: some View {
        riveVM.view()
    }
}

struct SmallArcticFoxView: View {
    @StateObject var riveVM =    RiveViewModel(fileName: "arcticfox", stateMachineName: "Small Fox")
    
    var body: some View {
        riveVM.view()
    }
}

#Preview {
    ArcticFoxView()
}
#Preview {
    SmallArcticFoxView()
}

