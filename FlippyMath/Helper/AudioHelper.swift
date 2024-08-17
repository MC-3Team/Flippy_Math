//
//  AudioHelper.swift
//  BambiniMath
//
//  Created by Ayatullah Ma'arif on 14/08/24.
//

import AVFoundation

class AudioHelper: ObservableObject {
    static let shared = AudioHelper()
    
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
            } catch {
                print("Error playing music: \(error.localizedDescription)")
            }
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
        musicPlayer?.volume = volume
    }
}
