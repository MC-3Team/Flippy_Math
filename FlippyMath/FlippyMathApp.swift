//
//  FlippyMathApp.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 16/08/24.
//

import SwiftUI

@main
struct FlippyMathApp: App {
    @StateObject private var audioHelper = AudioHelper.shared
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .navigationBarBackButtonHidden(true)
                .environmentObject(audioHelper)
        }
    }
}
