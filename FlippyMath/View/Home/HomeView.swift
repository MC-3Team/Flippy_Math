//
//  HomeView.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import SwiftUI
import Speech
import AVFoundation

struct HomeView: View {
    
    @StateObject var historyViewModel = HistoryViewModel()
    @StateObject private var viewModel = HomeViewModel()
    @AppStorage("isMute") private var isMute = false
    
    @EnvironmentObject var audioHelper: AudioHelper
    
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
                    
                    Button {
                        isMute.toggle()
                    } label: {
                        Image(isMute ? "MusicButtonDisabled" : "MusicButton")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.07, height: geometry.size.height * 0.10)
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

                    Button(action: {
                        viewModel.requestPermissions()
                    }, label: {
                        Image("PlayButton")
                            .resizable()
                            .frame(width: geometry.size.width * 0.13, height: geometry.size.height * 0.18)
                    }).padding(.top, geometry.size.width * 0.17)
                        .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.3)
                    
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
                .navigationDestination(isPresented: $viewModel.isGranted, destination: {
                    QuestionView(viewModel: QuestionViewModel(sequenceLevel: viewModel.getLastCompletedLevel(), parameter: .home))
                })
                .alert(isPresented: $viewModel.showSettingsAlert) {
                            Alert(
                                title: Text("Permissions Required"),
                                message: Text(viewModel.alertMessage),
                                primaryButton: .default(Text("Go to Settings")) {
                                    // Open app settings
                                    if let url = URL(string: UIApplication.openSettingsURLString) {
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                .onDisappear {
//                    audioHelper.pauseMusic()
                    withAnimation {
                        viewModel.animate = false
                    }
                }
                .onAppear {
                    historyViewModel.clearNavigation()
                    
                    viewModel.createSnowflakes(in: geometry.size)
                    
                    withAnimation {
                        viewModel.animate = true
                    }
                    if !audioHelper.isPlayingMusic() {
                                   audioHelper.playMusic(named: "comedy-kids", fileType: "mp3")
                               }
                    
//                    if !isMute {
//                        print("Playing lagi")
//                        audioHelper.playMusic(named: "comedy-kids", fileType: "wav")
//                    }
                }
                .onChange(of: isMute) { _, _ in
                    switch isMute {
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
