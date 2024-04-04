//
//  SoundManager.swift
//  Striker
//
//  Created by Oleg Yakushin on 4/4/24.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    var backgroundMusicPlayer: AVAudioPlayer?

    private init() {
        playBackgroundMusic()
    }

    func playBackgroundMusic() {
        let url = Bundle.main.url(forResource: "spaceSound", withExtension: "mp3")
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
            backgroundMusicPlayer?.numberOfLoops = -1 
            backgroundMusicPlayer?.play()
        } catch {
            print("Не удалось воспроизвести музыку.")
        }
    }

    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }

    func pauseBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }

    func resumeBackgroundMusic() {
        backgroundMusicPlayer?.play()
    }
}
