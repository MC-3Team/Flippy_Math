//
//  HistoryGridView.swift
//  FlippyMath
//
//  Created by William Handoko on 17/08/24.
//

import SwiftUI
import Routing

struct HistoryGridView: View {
    @StateObject var viewModel = HistoryViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var audioHelper: AudioHelper
    @EnvironmentObject private var router: Router<NavigationRoute>
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("Home_Background")
                    .resizable()
                    .ignoresSafeArea(.all)
                
                ScrollView([.vertical], showsIndicators: false) {
                    ZStack{
                        Image("HistoryLine")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                        
                        VStack(spacing: 20) {
                            ForEach(0..<4) { row in
                                if row % 2 == 0{
                                    HStack(spacing: 160) {
                                        ForEach(0..<3) { col in
                                            let index = row * 3 + col
                                            if index < viewModel.buttons.count {
                                                let button = viewModel.buttons[index]
                                                Button(action: {
                                                    router.navigate(to: .question(Int(button.sequence), .history))
                                                }, label: {
                                                    ZStack {
                                                        Image(button.imageName)
                                                            .resizable()
                                                        
                                                        if !button.isPassed {
                                                            Image("lock")
                                                                .resizable()
                                                                .padding(.top, 0.1)
                                                        }
                                                    }
                                                    .cornerRadius(16)
                                                    .aspectRatio(contentMode: .fit)
                                                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 4)
                                                    .frame(width: geometry.size.width * 0.18, height: geometry.size.width * 0.18)
                                                    
                                                })
                                                .disabled(!button.isPassed)
                                            }
                                            else {
                                                Spacer()
                                                    .frame(width: geometry.size.width * 0.18)
                                            }
                                        }
                                    }
                                }else {
                                    HStack(spacing: 160) {
                                        ForEach((0..<3).reversed(), id: \.self) { col in
                                            let index = row * 3 + col
                                            if index < viewModel.buttons.count {
                                                let button = viewModel.buttons[index]
                                                let _  = print(button.imageName)
                                                
                                                Button(action: {
                                                    router.navigate(to: .question(Int(button.sequence), .history))
                                                }, label: {
                                                    ZStack {
                                                        Image(button.imageName)
                                                            .resizable()
                                                        
                                                        if !button.isPassed {
                                                            Image("lock")
                                                                .resizable()
                                                                .padding(.top, 0.1)
                                                            
                                                        }
                                                    }
                                                    .cornerRadius(16)
                                                    
                                                    .aspectRatio(contentMode: .fit)
                                                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 4)
                                                    .frame(width: geometry.size.width * 0.18, height: geometry.size.width * 0.18)
                                                    
                                                })
                                                .disabled(!button.isPassed)
                                            }
                                            else {
                                                Spacer()
                                                    .frame(width: geometry.size.width * 0.18)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    .padding(.top, geometry.size.width * 0.1)
                    
                    //                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                
                Button(action: {
                    router.navigateToRoot()
                }, label: {
                    Image("HomeButton")
                        .resizable()
                        .frame(width: geometry.size.width * 0.11, height: geometry.size.height * 0.15)
                }).position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.08)
                
                    .onDisappear(perform: {
                        viewModel.clearNavigation()
                        //                    audioHelper.pauseMusic()
                    })
                    .onAppear {
                        //                    audioHelper.resumeMusic()
                        viewModel.buttons.forEach({
                            index in
                            print(index.imageName)
                        })
                    }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    HistoryGridView()
//        .previewInterfaceOrientation(.landscapeLeft)
//}
