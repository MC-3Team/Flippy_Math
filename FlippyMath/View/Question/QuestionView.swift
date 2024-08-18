//
//  QuestionView.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import SwiftUI

struct QuestionView: View {
    @StateObject private var viewModel: QuestionViewModel
    
    init(viewModel: QuestionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            QuestionLayout(viewModel: viewModel) { geometry in
                VStack {
                    switch viewModel.currentQuestionIndex {
                    case 0:
                        VStack {
                            
                        }
                        
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
                        ZStack {
                            HStack {
                                Image("Q5_2Cakes")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.55)
                                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                            }
                            
                            ForEach(0..<8, id: \.self) { index in
                                Image("Q5_Fly\(index + 1)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.05)
                                    .position(viewModel.randomPosition(geometry: geometry, index: index))
                            }
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
        }
    }
}

#Preview {
    QuestionView(viewModel: QuestionViewModel(level: 1))
}
