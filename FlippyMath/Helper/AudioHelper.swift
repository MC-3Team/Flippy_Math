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
    private var musicHomePlayer: AVAudioPlayer?
    private var musicQuestionPlayer: AVAudioPlayer?
    private var voicePlayer: AVAudioPlayer?

    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    func playSoundEffect(named name: String, fileType: String) {
        stopSoundEffect()  // Stop the previous sound effect if any
        if let url = Bundle.main.url(forResource: name, withExtension: fileType) {
            do {
                soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
                soundEffectPlayer?.play()
            } catch {
                print("Error playing sound effect: \(error.localizedDescription)")
            }
        }
    }
    
    func playVoiceOver(named name: String, fileType: String) {
        stopVoice()  // Stop the previous voice over if any
        if let url = Bundle.main.url(forResource: name, withExtension: fileType) {
            do {
                voicePlayer = try AVAudioPlayer(contentsOf: url)
                voicePlayer?.play()
            } catch {
                print("Error playing voice over: \(error.localizedDescription)")
            }
        }
    }
    
    func playMusicQuestion(named name: String, fileType: String, loop: Bool = true) {
        guard !isMute else { return }
        stopMusicHome()
        if let url = Bundle.main.url(forResource: name, withExtension: fileType) {
            do {
                musicQuestionPlayer = try AVAudioPlayer(contentsOf: url)
                musicQuestionPlayer?.numberOfLoops = loop ? -1 : 0
                musicQuestionPlayer?.play()
                setMusicQuestionVolume(0.5)
            } catch {
                print("Error playing music: \(error.localizedDescription)")
            }
        }
    }
    
    func playMusicHome(named name: String, fileType: String, loop: Bool = true) {
        guard !isMute else { return }
        stopMusicQuestion()
        if let url = Bundle.main.url(forResource: name, withExtension: fileType) {
            do {
                musicHomePlayer = try AVAudioPlayer(contentsOf: url)
                musicHomePlayer?.numberOfLoops = loop ? -1 : 0
                musicHomePlayer?.play()
                setMusicHomeVolume(0.5)
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
    
    func isPlayingMusicHome() -> Bool {
        return musicHomePlayer?.isPlaying ?? false
    }
    
    func isPlayingMusicQuestion() -> Bool {
        return musicQuestionPlayer?.isPlaying ?? false
    }
    
    func stopSoundEffect() {
        soundEffectPlayer?.stop()
        soundEffectPlayer = nil
    }
    
    func stopMusicHome() {
        musicHomePlayer?.stop()
        musicHomePlayer = nil
    }
    
    func stopMusicQuestion() {
        musicQuestionPlayer?.stop()
        musicQuestionPlayer = nil
    }
    
    func stopVoice() {
        voicePlayer?.stop()
        voicePlayer = nil
    }
    
    func stopAll() {
        stopSoundEffect()
        stopMusicHome()
        stopMusicQuestion()
        stopVoice()
    }
    
    func setSoundEffectVolume(_ volume: Float) {
        soundEffectPlayer?.volume = volume
    }
    
    func setMusicHomeVolume(_ volume: Float) {
        musicHomePlayer?.volume = isMute ? 0 : volume
    }
    
    func setMusicQuestionVolume(_ volume: Float) {
        musicQuestionPlayer?.volume = isMute ? 0 : volume
    }
}
