//
//  HistoryGridView.swift
//  FlippyMath
//
//  Created by William Handoko on 17/08/24.
//

import SwiftUI

struct HistoryGridView: View {
    @StateObject var viewModel = HistoryViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("BG")
                    .resizable()
                    .ignoresSafeArea(.all)
                
                GeometryReader { geometry in
                    NavigationLink {
                        HomeView()
                    } label: {
                        Image("HomeButton")
                            .resizable()
                            .frame(width: geometry.size.width * 0.11, height: geometry.size.height * 0.15)
                    }
                    .position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
                    
                    ScrollView([.vertical, .horizontal], showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(0..<3) { row in
                                HStack(spacing: 20) {
                                    ForEach(0..<3) { col in
                                        let index = row * 3 + col
                                        if index < viewModel.buttons.count {
                                            let button = viewModel.buttons[index]
                                    
                                            
                                            NavigationLink(destination: button.destinationView, tag: Int(button.sequence), selection: $viewModel.activeButtonIndex) {
                                                Image(button.imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: geometry.size.width / 3.2, height: geometry.size.height / 4)
                                                    .cornerRadius(16)
                                                    .overlay(
                                                        button.isPassed ? nil : Image("lock")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: geometry.size.width / 3.2, height: geometry.size.height / 4)
                                                            .cornerRadius(16)
                                                    )
                                            }
                                            .disabled(!button.isPassed)
                                        } else {
                                            Spacer()
                                                .frame(width: geometry.size.width / 3.2, height: geometry.size.height / 4)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .padding(.top, geometry.size.height * 0.2)
                    }
                    .onDisappear(perform: {
                        viewModel.clearNavigation()
                    })
                }
            }
        }
    }
}

#Preview {
    HistoryGridView()
        .previewInterfaceOrientation(.landscapeLeft)
}
