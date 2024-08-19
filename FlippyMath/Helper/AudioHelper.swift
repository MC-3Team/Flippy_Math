//
//  AudioHelper.swift
//  FlippyMath
//
//  Created by Ayatullah Ma'arif on 14/08/24.
//

import AVFoundation
import SwiftUI

class AudioHelper: ObservableObject {
    static let shared = AudioHelper()
    
    @AppStorage("isMute") private var isMute = false
    
    private var soundEffectPlayer: AVAudioPlayer?
    private var musicPlayer: AVAudioPlayer?
    private var voicePlayer: AVAudioPlayer?

    func playSoundEffect(named name: String, fileType: String ) {
        if let url = Bundle.main.url(forResource: name, withExtension: fileType) {
            do {
                soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
                soundEffectPlayer?.play()
            } catch {
                print("Error playing sound effect: \(error.localizedDescription)")
            }
        }
    }
    
    func playVoiceOver(named name: String, fileType: String ) {
        if let url = Bundle.main.url(forResource: name, withExtension: fileType) {
            do {
                voicePlayer = try AVAudioPlayer(contentsOf: url)
                voicePlayer?.play()
            } catch {
                print("Error playing sound effect: \(error.localizedDescription)")
            }
        }
    }
    
    func playMusic(named name: String, fileType: String, loop: Bool = true) {
        stopMusic() // Stop any currently playing music
        if let url = Bundle.main.url(forResource: name, withExtension: fileType) {
            do {
                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer?.numberOfLoops = loop ? -1 : 0
                musicPlayer?.play()
                setMusicVolume(0.3)
            } catch {
                print("Error playing music: \(error.localizedDescription)")
            }
        }
    }
    
    func getAudioDuration(named name: String, fileType: String) -> TimeInterval? {
            if let path = Bundle.main.path(forResource: name, ofType: fileType) {
                let url = URL(fileURLWithPath: path)
                do {
                    let audioPlayer = try AVAudioPlayer(contentsOf: url)
                    return audioPlayer.duration
                } catch {
                    print("Error getting audio duration: \(error)")
                    return nil
                }
            } else {
                print("Audio file not found")
                return nil
            }
        }
    
    func stopSoundEffect() {
        soundEffectPlayer?.stop()
        soundEffectPlayer = nil
    }
    
    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
    }
    
    func stopVoice() {
        voicePlayer?.stop()
        voicePlayer = nil
    }
    
    func stopAll() {
        stopSoundEffect()
        stopMusic()
    }
    
    func setSoundEffectVolume(_ volume: Float) {
        soundEffectPlayer?.volume = volume
    }
    
    func setMusicVolume(_ volume: Float) {
        musicPlayer?.volume = isMute ? 0 : volume
    }
}
