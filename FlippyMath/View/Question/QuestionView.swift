//
//  QuestionView.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import SwiftUI

struct QuestionView: View {
    @StateObject var viewModel: QuestionViewModel
    
    init(viewModel: QuestionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        QuestionLayout(viewModel: viewModel) { geometry in
            VStack {
                switch viewModel.currentQuestionIndex {
                case 0:
                    VStack {}
                case 1:
                    Image("Q1_Penguins")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.70)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.65)
                case 2:
                    HStack {
                        VStack {
                            if viewModel.currentMessageIndex > 1 {
                                Image("")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.30)
                                    .position(x: geometry.size.width / 5.5, y: geometry.size.height * 0.45)
                            } else {
                                Image("Q2_Hats")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.30)
                                    .position(x: geometry.size.width / 5.5, y: geometry.size.height * 0.45)
                            }
                            
                            Image("Q2_Table")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.45)
                                .position(x: geometry.size.width / 5, y: geometry.size.height * 0.1)
                        }
                        
                        if viewModel.currentMessageIndex > 1 {
                            Image("Q2_PenguinWithHats")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.55)
                                .position(x: geometry.size.width / 5.5, y: geometry.size.height * 0.60)
                        } else {
                            Image("Q2_Penguins")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.55)
                                .position(x: geometry.size.width / 5.5, y: geometry.size.height * 0.65)
                        }
                    }
                    
                case 3:
                    VStack {
                        switch viewModel.currentMessageIndex {
                        case ..<2:
                            IdleBalloonView()
                        case 2:
                            FlyingBalloonView()
                        default:
                            IdleBalloon2View()
                        }
                    }
                    
                case 4:
                    HStack {
                        if viewModel.currentMessageIndex < 1 {
                            Image("Q4_8Cakes")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.75)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                        } else {
                            Image("Q4_6Cakes")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.55)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                        }
                    }
                    
                case 5:
                    if viewModel.currentMessageIndex < 1 {
                        ZStack {
                            HStack {
                                Image("Q5_2Cakes")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.55)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                            }
                        }
                    } else if viewModel.currentMessageIndex < 4 {
                        ZStack {
                            HStack {
                                Image("Q5_2Cakes")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.55)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                            }
                            
                            Image("Q5_Fly1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.05)
                                .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.7)
                            
                            Image("Q5_Fly2")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.05)
                                .position(x: geometry.size.width * 0.16, y: geometry.size.height * 0.4)
                            
                            Image("Q5_Fly3")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.05)
                                .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.8)
                            
                            Image("Q5_Fly4")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.05)
                                .position(x: geometry.size.width * 0.3, y: geometry.size.height * 0.35)
                            
                            Image("Q5_Fly5")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.05)
                                .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.55)
                            
                            Image("Q5_Fly6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.05)
                                .position(x: geometry.size.width * 0.45, y: geometry.size.height * 0.81)
                            
                            Image("Q5_Fly7")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.05)
                                .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.80)
                            
                            Image("Q5_Fly8")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.05)
                                .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.4)
                            
                            Image("Q5_Fly9")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.05)
                                .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.6)
                        }
                    } else {
                        ZStack {
                            HStack {
                                Image("Q5_2Cakes")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.55)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                            }
                            
                            Image("Q5_Fly1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.05)
                                .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.7)
                            
                            Image("Q5_Fly9")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.05)
                                .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.6)
                        }
                    }
                case 6:
                    ZStack {
                        if viewModel.currentMessageIndex < 3 {
                            HStack {
                                Image("Q6_ArcticFox")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.2)
                                    .position(x: geometry.size.width / 3, y: geometry.size.height * 0.6)
                                
                                Image("Q6_ArcticFox")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.2)
                                    .position(x: geometry.size.width / 5, y: geometry.size.height * 0.6)
                            }
                            
                            Image("Q6_BabyFox")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                                .position(x: geometry.size.width / 2.1, y: geometry.size.height * 0.74)
                            
                            Image("Q6_BabyFox")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                                .position(x: geometry.size.width / 1.7, y: geometry.size.height * 0.76)
                        } else {
                            HStack {
                                Image("Q6_ArcticFox")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.2)
                                    .position(x: geometry.size.width / 3, y: geometry.size.height * 0.6)
                                
                                Image("Q6_ArcticFox")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.2)
                                    .position(x: geometry.size.width / 5, y: geometry.size.height * 0.6)
                            }
                            
                            Image("Q6_BabyFox")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                                .position(x: geometry.size.width / 2.1, y: geometry.size.height * 0.74)
                            
                            Image("Q6_BabyFox")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                                .position(x: geometry.size.width / 1.7, y: geometry.size.height * 0.76)
                            
                            Image("Q6_BabyFox")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                                .position(x: geometry.size.width / 4.5, y: geometry.size.height * 0.70)
                            
                            Image("Q6_BabyFox")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                                .position(x: geometry.size.width / 8, y: geometry.size.height * 0.74)
                            
                            Image("Q6_BabyFox")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                                .position(x: geometry.size.width / 1.25, y: geometry.size.height * 0.75)
                            
                            Image("Q6_BabyFox")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.08)
                                .position(x: geometry.size.width / 1.1, y: geometry.size.height * 0.7)
                        }
                    }
                    
                case 7:
                    ZStack {
                        if viewModel.currentMessageIndex < 2 {
                            Image("Q7_PinataRope")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 1.05)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.16)
                            
                            Image("Q7_Pinata")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.45)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.4)
                        } else if viewModel.currentMessageIndex < 3 {
                            Image("Q7_PinataRope")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 1.05)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.16)
                            
                            Image("Q7_CrackedPinata")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.45)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.4)
                        } else if viewModel.currentMessageIndex < 4 {
                            Image("Q7_20Candies")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.9)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                        } else {
                            Image("Q7_15Candies")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.70)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                        }
                    }
                    
                case 8:
                    if viewModel.currentMessageIndex < 2 {
                        PolarBearView(isOpen: false)
                    } else {
                        PolarBearView(isOpen: true)
                    }
                    
                default:
                    Image("DefaultImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.70)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.65)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.audioHelper.playMusic(named: "birthday-party", fileType: "wav")
        }
        
    }
}
                                  
