//
//  VideoPlayerViewModel.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import AVKit
import Foundation

final class VideoPlayerViewModel: ObservableObject {
    @Published private(set) var player: AVPlayer?
    @Published var isMuted: Bool = false
    @Published var isPlayerPaused: Bool = true
    @Published var seekPos: Double = 0.0

    var currentItem: AVPlayerItem? {
        player?.currentItem
    }

    func toogleVideoPlayback() {
        if isPlayerPaused {
            player?.play()
        } else {
            player?.pause()
        }
        isPlayerPaused.toggle()
    }

    func play() {
        player?.play()
        isPlayerPaused = false
    }

    func pause() {
        player?.pause()
        isPlayerPaused = true
    }

    func stop() {
        player?.pause()
        isPlayerPaused = true
        player?.seek(to: .zero)
    }

    func loadVideo(_ url: URL) {
        player = AVPlayer(url: url)
        isMuted = player?.isMuted ?? false

        player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.2, preferredTimescale: 600),
            queue: nil
        ) { time in
            guard let item = self.player?.currentItem else {
              return
            }
            self.seekPos = time.seconds / item.duration.seconds
          }
    }

    func toggleVolume() {
        player?.isMuted.toggle()
        isMuted = player?.isMuted ?? false
    }

    func seek(to time: CMTime) {
        player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
}
