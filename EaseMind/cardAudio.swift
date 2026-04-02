//
//  cardAudio.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-03-03.
//

import Foundation
import UIKit
import AVFoundation
class cardAudio {
    static let shared = cardAudio()
    private var player: AVAudioPlayer?

    private init() {}

    func setupAudio() {
        guard let url = Bundle.main.url(forResource: "fluteTone", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
        } catch {
            print("Audio error: \(error)")
        }
    }

    func stop() {
        player?.stop()
    }
}
