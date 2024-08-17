//
//  SplashView.swift
//  BambiniMath
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
            QuestionView()
        } else {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).onAppear {
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
