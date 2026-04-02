//
//  playMusicList.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-03-04.
//


import AVFoundation

class AudioManagerList {
    static let shared = AudioManagerList()
    
    var player: AVAudioPlayer?
    
    func playSound(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("File not found: \(fileName).mp3")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1 // infinite loop
            player?.play()
        } catch {
            print("Failed to play audio: \(error)")
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func resume() {
        player?.play()
    }
    
    func stop() {
        player?.stop()
    }
    
    func setVolume(_ volume: Float) {
        player?.volume = volume
    }
}
