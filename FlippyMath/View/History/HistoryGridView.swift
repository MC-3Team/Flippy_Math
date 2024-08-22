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
                            .padding(.top, geometry.size.width * 0.32)
                            .padding(.bottom, geometry.size.width * 0.32)
                            .padding(.leading, geometry.size.height * 0.2)
                            .padding(.trailing, geometry.size.height * 0.2)


                        VStack(spacing: 80) {
                            ForEach(0..<4) { row in
                                if row % 2 == 0{
                                    HStack(spacing: 160) {
                                        ForEach(0..<3) { col in
                                            let index = row * 3 + col
                                            if index < viewModel.buttons.count {
                                                
                                                let button = viewModel.buttons[index]
                                                let _  = print(button.imageName)
                                                
                                                
                                                Button(action: {
                                                    router.navigate(to: .question(Int(button.sequence), .history))
                                                }, label: {
                                                    Image(button.imageName)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .cornerRadius(16)
                                                        .frame(width: geometry.size.width * 0.2)
                                                        .overlay(
                                                            GeometryReader{ geo2 in
                                                                button.isPassed ? nil : Image("lock")
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .cornerRadius(16)
                                                                    .position(x: geo2.size.width * 0.514 , y: geo2.size.height * 0.524)
                                                                    .frame(width: geo2.size.width * 1.279, height: geo2.size.height * 1.289)
                                                            }
                                                        )
                                                })
                                                .disabled(!button.isPassed)
                                            }
                                            else {
                                                Spacer()
                                                    .frame(width: geometry.size.width / 3.1, height: geometry.size.height / 4.0)
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
                                                    Image(button.imageName)
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .cornerRadius(16)
                                                        .frame(width: geometry.size.width * 0.2)
                                                        .overlay(
                                                            GeometryReader{ geo2 in
                                                                button.isPassed ? nil : Image("lock")
                                                                    .resizable()
                                                                    .aspectRatio(contentMode: .fit)
                                                                    .cornerRadius(16)
                                                                    .position(x: geo2.size.width * 0.516 , y: geo2.size.height * 0.525)
                                                                    .frame(width: geo2.size.width * 1.279, height: geo2.size.height * 1.289)
                                                            }
                                                        )
                                                })
                                                .disabled(!button.isPassed)
                                            }
                                            else {
                                                Spacer()
                                                    .frame(width: geometry.size.width * 0.2)
                                            }
                                        }
                                    }
                                }
                            }
                        }
        
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.7)
//                    .padding()
//                    .padding(.top, geometry.size.height * 0.11)
                }
                
                Button(action: {
                    router.navigateToRoot()
                }, label: {
                    Image("HomeButton")
                        .resizable()
                        .frame(width: geometry.size.width * 0.11, height: geometry.size.height * 0.15)
                }).position(x: geometry.size.width * 0.06, y: geometry.size.height * 0.06)
                
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
