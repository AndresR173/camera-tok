//
//  AVPlayer+Dependencies.swift
//  CameraTok
//
//  Created by Andres Rojas on 15/08/23.
//

import AVKit
import Dependencies
import Foundation

enum AVPlayerGeneratorDependencyKey: DependencyKey {
    static let liveValue: AVPlayerGenerator = AVPlayerGenerator { AVPlayer() }
    static let previewValue: AVPlayerGenerator = AVPlayerGenerator { MockAVPlayer() }
    static let testValue: AVPlayerGenerator = AVPlayerGenerator { MockAVPlayer() }

    final class MockAVPlayer: AVPlayer {
        var playCalled: Bool = false
        var pauseCalled: Bool = false
        var time: CMTime = .zero
        var avPlaverItem: AVPlayerItem?
        
        override var currentItem: AVPlayerItem? {
            avPlaverItem
        }

        override func play() {
            playCalled = true
        }

        override func pause() {
            pauseCalled = true
        }
        override func seek(to time: CMTime, toleranceBefore: CMTime, toleranceAfter: CMTime) {
            self.time = time
        }

        override func seek(to time: CMTime) {
            self.time = time
        }

        override func replaceCurrentItem(with item: AVPlayerItem?) {
            avPlaverItem = item
        }
    }
}

extension DependencyValues {
    var avPlayer: AVPlayerGenerator {
        get { self[AVPlayerGeneratorDependencyKey.self] }
        set { self[AVPlayerGeneratorDependencyKey.self] = newValue }
    }
}
