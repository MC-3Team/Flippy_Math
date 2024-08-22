//
//  BalloonView.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 22/08/24.
//

import SwiftUI
import RiveRuntime

struct BalloonView: View {
    @StateObject var riveVM = RiveViewModel(fileName: "balloon")

    var body: some View {
        riveVM.view()
    }
}

#Preview {
    BalloonView()
}
