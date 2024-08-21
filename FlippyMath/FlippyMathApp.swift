//
//  FlippyMathApp.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 16/08/24.
//

import SwiftUI
import Routing

@main
struct FlippyMathApp: App {
    @StateObject private var audioHelper = AudioHelper.shared
    @StateObject private var router: Router<NavigationRoute> = .init()
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .navigationBarBackButtonHidden(true)
                .environmentObject(audioHelper)
                .environmentObject(router)
        }
    }
}
