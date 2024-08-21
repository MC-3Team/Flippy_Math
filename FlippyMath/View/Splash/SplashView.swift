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

    var body: some View {
        if isNavigating {
            HomeView()
//            QuestionView(viewModel: QuestionViewModel(level: 0))
        } else {
            SplashAnimation()
                .onAppear {
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
