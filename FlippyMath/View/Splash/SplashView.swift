//
//  SplashView.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import SwiftUI

struct SplashView: View {
    @AppStorage("isFirst") private var isFirst = true
    @StateObject private var viewModel : SplashViewModel = SplashViewModel()
    @State private var isNavigating = false
    @EnvironmentObject var audioHelper: AudioHelper
    
    var body: some View {
        if isNavigating {
            HomeView()
        } else {
            SplashAnimation()
                .onAppear {
                    audioHelper.playSoundEffect(named: "splash-audio", fileType: "wav")
                if isFirst {
                    viewModel.insertAllData()
                    isFirst = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                      isNavigating = true
                                  }
            }
        }
      
    }
}

#Preview {
    SplashView()
}
