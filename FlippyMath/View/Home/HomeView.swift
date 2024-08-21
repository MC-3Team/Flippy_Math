//
//  HomeView.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var historyViewModel = HistoryViewModel()
    @StateObject private var viewModel = HomeViewModel()
    
    var audioHelper = AudioHelper.shared
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack{
                ZStack {
                    Image("Home_Background")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    Image("Home_Iglo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 1.05)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                    
                    Image("LogoFlippyMath")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.45)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.2)
                    
                    PenguinsHomeView()
                        .frame(width: geometry.size.width * 0.65)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.68)
                    
                    //Ganti Button ya wil jan lupa
                    Button{
                        viewModel.isMusicOn.toggle()
                    } label: {
                        Image("MusicButton")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.07)
                    }
                    .position(x: geometry.size.width * 0.94, y: geometry.size.height * 0.06)
                    
                    NavigationLink {
                        HistoryGridView()
                    } label: {
                        Image("Record")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.07)
                    }
                    .padding(.top,geometry.size.width * 0.17)
                    .position(x: geometry.size.width * 0.94, y: geometry.size.height * 0.06)
                    
                    NavigationLink {
                        QuestionView(viewModel: QuestionViewModel(level: 0))
                    } label: {
                        Image("PlayButton")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.1)
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.45)
                    
                    // Snowflakes
                    ForEach(viewModel.snowflakes) { snowflake in
                        Image(snowflake.imageName)
                            .resizable()
                            .frame(width: snowflake.size, height: snowflake.size)
                            .rotationEffect(.degrees(viewModel.animate ? 360 : 0))
                            .animation(Animation.linear(duration: snowflake.rotationDuration).repeatForever(autoreverses: false), value: viewModel.animate)
                            .position(x: snowflake.xPosition, y: viewModel.animate ? geometry.size.height + snowflake.size : -snowflake.size)
                            .animation(Animation.linear(duration: snowflake.duration).delay(snowflake.delay).repeatForever(autoreverses: false), value: viewModel.animate)
                    }
                }
                .onAppear {
                    historyViewModel.clearNavigation()
                    viewModel.createSnowflakes(in: geometry.size)
                    withAnimation {
                        viewModel.animate = true
                    }
                }
                .onChange(of: viewModel.isMusicOn) { _, _ in
                    switch viewModel.isMusicOn{
                    case true :
                        audioHelper.playMusic(named: "comedy-kids", fileType: "wav")
                    case false :
                        audioHelper.stopMusic()
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}
#Preview {
    HomeView()
}
