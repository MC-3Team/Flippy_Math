//
//  HomeView.swift
//  FlippyMath
//
//  Created by Enrico Maricar on 05/08/24.
//

import SwiftUI
import Speech
import AVFoundation
import Routing

struct HomeView: View {
    
    @StateObject var historyViewModel = HistoryViewModel()
    @StateObject private var viewModel = HomeViewModel()
    @AppStorage("isMute") private var isMute = false
    @EnvironmentObject private var router: Router<NavigationRoute>
    @EnvironmentObject var audioHelper: AudioHelper
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        GeometryReader { geometry in
            RoutingView(stack: $router.stack) {
                ZStack {
                    if verticalSizeClass == .regular{
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
                        
                        BalloonView()
                            .frame(width: geometry.size.width * 0.17)
                            .position(x: geometry.size.width * 0.74, y: geometry.size.height / 2)
                        
                        BalloonView()
                            .frame(width: geometry.size.width * 0.17)
                            .position(x: geometry.size.width * 0.28, y: geometry.size.height / 2)
                        
                        PenguinsHomeView()
                            .frame(width: geometry.size.width * 0.65)
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.68)
                    }
                    
                    else {
                        Image("BgHomePhone")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                        
                        Image("Home_Iglo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.8)
                            .position(x: geometry.size.width * 0.55, y: geometry.size.height * 0.63)
                        
                        Image("LogoFlippyMath")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.4)
                            .position(x: geometry.size.width * 0.55, y: geometry.size.height * 0.153)
                        
                        BalloonView()
                            .frame(width: geometry.size.width * 0.13)
                            .position(x: geometry.size.width * 0.72, y: geometry.size.height * 0.53)
                        
                        BalloonView()
                            .frame(width: geometry.size.width * 0.13)
                            .position(x: geometry.size.width * 0.38, y: geometry.size.height * 0.53)
                        
                        PenguinsHomeView()
                            .frame(width: geometry.size.width * 0.5)
                            .position(x: geometry.size.width * 0.55, y: geometry.size.height * 0.73)
                        
                    }
                        
                        Button {
                            isMute.toggle()
                        } label: {
                            Image(isMute ? "MusicButtonDisabled" : "MusicButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.07)
                        }
                        .position(x:verticalSizeClass == .compact ? geometry.size.width * 1 : geometry.size.width * 0.94, y: verticalSizeClass == .compact ? geometry.size.height * 0.1 : geometry.size.height * 0.08)
                        
                        Button(action: {
                            print("Sampe sini")
                            router.navigate(to: .history)
                        }, label: {
                            Image("Record")
                            
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.07)
                        }).padding(.top,geometry.size.width * 0.17)
                        .position(x: verticalSizeClass == .compact ? geometry.size.width * 1 : geometry.size.width * 0.94, y: verticalSizeClass == .compact ? geometry.size.height * 0.1 : geometry.size.height * 0.08)
                        
                        Button(action: {
                            viewModel.requestPermissions()
                        }, label: {
                            Image("PlayButton")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.13, height: geometry.size.height * 0.18)
                        }).padding(.top, geometry.size.width * 0.17)
                        .position(x: verticalSizeClass == .compact ? geometry.size.width * 0.55 : geometry.size.width * 0.5, y: geometry.size.height * 0.3)
       
                    
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
                .onChange(of: viewModel.isGranted) {
                    if viewModel.isGranted {
                        router.navigate(to: .question(viewModel.getLastCompletedLevel(), .home))
                        viewModel.isGranted = false
                    }
                }
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
                    audioHelper.stopMusicHome()
                }
                .onAppear {
                    historyViewModel.clearNavigation()
                    
                    viewModel.createSnowflakes(in: geometry.size)
                    
                    withAnimation {
                        viewModel.animate = true
                    }
                    
                    if !isMute && !audioHelper.isPlayingMusicHome() {
                        audioHelper.playMusicHome(named: "comedy-kids", fileType: "mp3")
                    }
                }
                .onChange(of: isMute) { _, _ in
                    print(isMute)
                    switch isMute {
                    case true :
//                        audioHelper.stopMusicHome()
                        audioHelper.setMusicHomeVolume(0.0)
                    case false :
//                        audioHelper.playMusicHome(named: "comedy-kids", fileType: "mp3")
                        audioHelper.setMusicHomeVolume(0.3)
                        if(!audioHelper.isPlayingMusicHome()){
                            audioHelper.playMusicHome(named: "comedy-kids", fileType: "mp3")

                        }

                    }
                }
                .navigationBarHidden(true)
            }
            

        }
    }
}

#Preview {
    HomeView()
}
