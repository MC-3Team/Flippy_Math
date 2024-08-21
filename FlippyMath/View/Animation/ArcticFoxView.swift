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
    
    @Binding var isPlay: Bool

    var body: some View {
        riveVM.view()
            .onAppear(){
                riveVM.setInput("isPlay", value: isPlay)
            }
            .onChange(of: isPlay, { oldValue, newValue in
                riveVM.setInput("isPlay", value: isPlay)
            })
    }
}

struct BabyFoxView: View {
    @StateObject var riveVM =    RiveViewModel(fileName: "arcticfox", stateMachineName: "Small Fox")
    
    @Binding var isPlay: Bool
    var body: some View {
        riveVM.view()
            .onAppear(){
                riveVM.setInput("isPlay", value: isPlay)
            }
            .onChange(of: isPlay, { oldValue, newValue in
                riveVM.setInput("isPlay", value: isPlay)
            })
    }
}

#Preview {
    ArcticFoxView(isPlay: .constant(true))
}
#Preview {
    ArcticFoxView(isPlay: .constant(true))
}

