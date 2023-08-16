//
//  AVService+Dependencies.swift
//  CameraTok
//
//  Created by Andres Rojas on 15/08/23.
//

import Dependencies
import Foundation

enum AVServiceDependencyKey: DependencyKey {
    static let liveValue: AVServiceAPI = AVService()
    static let previewValue: AVServiceAPI = MockAVService()
    static let testValue: AVServiceAPI = MockAVService()

    class MockAVService: AVServiceAPI {
        var isMuted: Bool = true

        func updateMutedStatus(isMuted: Bool) {
            self.isMuted = isMuted
        }

        func setDelegate(_ delegate: AVServiceDelegate?) {
            self.avDelegate = delegate
        }
        var currentVolume: Float = 0.3
        weak var avDelegate: AVServiceDelegate?
    }
}

extension DependencyValues {
    var avService: AVServiceAPI {
        get { self[AVServiceDependencyKey.self] }
        set { self[AVServiceDependencyKey.self] = newValue }
    }
}
