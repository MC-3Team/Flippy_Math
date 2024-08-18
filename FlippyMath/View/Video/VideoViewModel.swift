//
//  VideoViewModel.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 10/08/24.
//

import Foundation
import AVKit

class VideoViewModel: ObservableObject{
  
    @Published var isFinishPlayed = false
    var player: AVPlayer
    
    init(videoURL: URL) {
        player = AVPlayer(url: videoURL)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
    }
    
    @objc private func playerDidFinishPlaying() {
        isFinishPlayed = true
    }
    
    func replayVideo() {
        player.seek(to: .zero)
        player.play()
        isFinishPlayed = false
    }
}
