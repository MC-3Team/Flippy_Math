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
                    // Background
                    Image("BG") // Replace with your background asset name
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                    
                    Image("Iglo")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea(.all)
                    
                    Image("Penguin")
                        .padding(.top,geometry.size.height * 0.2)
                    
                    //Ganti Button ya wil jan lupa
                    Button{
                        viewModel.isMusicOn.toggle()
                    } label: {
                        Image("MusicButton")
                            .resizable()
                            .frame(width: geometry.size.width * 0.07, height: geometry.size.height * 0.10)
                    }
                    .position(x: geometry.size.width * 0.94, y: geometry.size.height * 0.06)
                    
                    NavigationLink {
                        HistoryGridView()
                    } label: {
                        Image("Record")
                            .resizable()
                            .frame(width: geometry.size.width * 0.07, height: geometry.size.height * 0.10)
                    }
                    .padding(.top,geometry.size.width * 0.17)
                    .position(x: geometry.size.width * 0.94, y: geometry.size.height * 0.06)
                    
                    NavigationLink {
                        QuestionView(viewModel: QuestionViewModel(level: 0))
                    } label: {
                        Image("PlayButton")
                            .resizable()
                            .frame(width: geometry.size.width * 0.13, height: geometry.size.height * 0.18)
                    }
                    .padding(.top,geometry.size.width * 0.17)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.3)
                    
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
        }
    }
}
#Preview {
    HomeView()
}
