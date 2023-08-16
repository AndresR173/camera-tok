//
//  VideoPlayerViewModel.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import AVKit
import Dependencies
import Foundation

final class VideoPlayerViewModel: ObservableObject {
    @Published private(set) var player: AVPlayer?
    @Published var isMuted: Bool = false
    @Published var isPlayerPaused: Bool = true
    @Published var seekPos: Double = 0.0
    @Published var volume: Double = 0.0

    @Dependency(\.avService) private var avService: AVServiceAPI
    @Dependency(\.avPlayer) private var avPlayer: AVPlayer
    @UserDefaultsWrapper(key: "likedAssets", defaultValue: [:])
    var likedAssets: [String: Bool]

    func toggleVideoPlayback() {
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
        let item = AVPlayerItem(url: url)
        player = avPlayer
        player?.replaceCurrentItem(with: item)
        player?.isMuted = avService.isMuted
        dump(avService.isMuted)
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

        avService.setDelegate(self)
    }

    func toggleVolume() {
        guard avService.currentVolume > 0 else { return }
        player?.isMuted.toggle()
        avService.updateMutedStatus(isMuted: player?.isMuted ?? false)
        isMuted = player?.isMuted ?? false
    }

    func seek(to time: CMTime) {
        player?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }

    func changeLikeStatus(for asset: inout VideoAsset) {
        asset.liked.toggle()
        likedAssets[asset.id] = asset.liked
    }
}

extension VideoPlayerViewModel: AVServiceDelegate {
    func updateVolume(to volume: Float) {
        isMuted = volume == 0
        avService.updateMutedStatus(isMuted: isMuted)
        player?.isMuted = isMuted
    }
}
