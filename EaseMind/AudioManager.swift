//
//  Untitled.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-03-03.
//

import AVFoundation

class AudioManager {
    
    static let shared = AudioManager()
    var alreadyPlayed = false
    private var player: AVAudioPlayer?
    private var isMuted = false
    
    private init() {}
    
    func setupAudio() {
        guard let url = Bundle.main.url(forResource: "fluteTone", withExtension: "mp3") else {
            print("Audio file not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1 // 
            player?.prepareToPlay()
            
        } catch {
            print("Error setting up audio: \(error)")
        }
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.stop()
    }
    
    func toggleMute() {
        guard let player = player else { return }
        
        if isMuted {
            player.volume = 1.0
        } else {
            player.volume = 0.0
        }
        
        isMuted.toggle()
    }
}
