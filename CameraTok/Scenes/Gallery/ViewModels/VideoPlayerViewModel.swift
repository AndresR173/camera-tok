//
//  VideoPlayerViewModel.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import AVKit
import Foundation

final class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    func loadVideo(_ url: URL) {
        player = AVPlayer(url: url)
    }

    func toggleVolume() {
        player?.isMuted.toggle()
    }
}
