//
//  VideoView.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 10/08/24.
//

import SwiftUI

struct VideoView: View {
    
//    @AppStorage("username") var username: String = "Guest"
    
    @StateObject private var videoVM = VideoViewModel(videoURL: Bundle.main.url(forResource: "TestVideo", withExtension: "mp4")!)
    
    var body: some View {
        ZStack {
            CustomVideoPlayerView(player: videoVM.player)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    videoVM.player.play()
                }
            
            if videoVM.isFinishPlayed {
                VStack {
                    Spacer()
                    HStack {
                        Button("Replay") {
                            videoVM.replayVideo()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("Next") {
                            // Handle next video action
                        }
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

#Preview {
    VideoView()
}
