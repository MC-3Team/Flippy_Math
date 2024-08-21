//
//  RewardAnimationView.swift
//  FlippyMath
//
//  Created by Rajesh Triadi Noftarizal on 21/08/24.
//

import SwiftUI
import RiveRuntime

struct RewardAnimationView: View {
    
    @StateObject var riveVM = RiveViewModel(fileName: "reward")
    
    var body: some View {
        riveVM.view()
            
    }
}

#Preview {
    RewardAnimationView()
}
