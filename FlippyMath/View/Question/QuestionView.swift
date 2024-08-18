//
//  QuestionView.swift
//  BambiniMath
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
                    if viewModel.currentQuestionIndex == 0 {
                        Image("Q1_Penguins")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.70)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.65)
                    } else if viewModel.currentQuestionIndex == 1 {
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
                    } else if viewModel.currentQuestionIndex == 2 {
                        VStack {
                            if viewModel.currentMessageIndex < 2{
                                IdleBalloonView()
                            }
                            else if viewModel.currentMessageIndex == 2{
                                FlyingBalloonView()
                            }
                            else if viewModel.currentMessageIndex > 2{
                                IdleBalloon2View()
                            }
                        }
                    } else if viewModel.currentQuestionIndex == 3{
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
                    } else {
                        Image("DefaultImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.70)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.65)
                    }
                }
            }
        }
    }
}

#Preview {
    QuestionView(viewModel: QuestionViewModel(level: 0))
}
