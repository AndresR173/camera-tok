//
//  VideoPlayerViewModelTests.swift
//  CameraTokTests
//
//  Created by Andres Rojas on 15/08/23.
//

@testable
import CameraTok
import XCTest
import Dependencies
import AVKit

final class VideoPlayerViewModelTests: XCTestCase {
    var mockAVService: AVServiceDependencyKey.MockAVService!
    var mockAVPlayer: AVPlayerGeneratorDependencyKey.MockAVPlayer!

    var sut: VideoPlayerViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAVService = AVServiceDependencyKey.MockAVService()
        mockAVPlayer = AVPlayerGeneratorDependencyKey.MockAVPlayer()

        sut = withDependencies({
            $0.avPlayer = .init({
                self.mockAVPlayer
            })
        }, operation: {
            VideoPlayerViewModel()
        })

        let url = URL(string: "test.com")!
        sut.loadVideo(url)
    }
}

extension VideoPlayerViewModelTests {
    func testLoadVideo() throws {
        XCTAssertNotNil(sut.player)
        XCTAssertNotNil(sut.player?.currentItem)
    }

    func testVideoControls() throws {
        sut.play()
        XCTAssertTrue(mockAVPlayer.playCalled)

        sut.pause()
        XCTAssertTrue(mockAVPlayer.pauseCalled)
    }

    func testPlayerStop() throws {
        sut.play()
        XCTAssertTrue(mockAVPlayer.playCalled)

        let time = CMTime(seconds: 3, preferredTimescale: 300)
        sut.seek(to: time)
        XCTAssertEqual(time, mockAVPlayer.time)

        sut.stop()
        XCTAssertEqual(mockAVPlayer.time, .zero)
        XCTAssertTrue(mockAVPlayer.pauseCalled)
    }

    func testPlayerToggleVolume() {
        XCTAssertTrue(mockAVPlayer.isMuted)
        sut.toggleVolume()
        XCTAssertFalse(mockAVPlayer.isMuted)
        sut.toggleVolume()
        XCTAssertTrue(mockAVPlayer.isMuted)
    }

    func testPlayerToggleVideoPlayBack() {
        XCTAssertTrue(sut.isPlayerPaused)
        sut.toggleVideoPlayback()
        XCTAssertTrue(mockAVPlayer.playCalled)
        sut.toggleVideoPlayback()
        XCTAssertTrue(mockAVPlayer.pauseCalled)
    }
}
