//
//  AVService.swift
//  CameraTok
//
//  Created by Andres Rojas on 15/08/23.
//

import AVFoundation
import Combine
import Foundation

protocol AVServiceDelegate: AnyObject {
    func updateVolume(to volume: Float)
}

protocol AVServiceAPI {
    func setDelegate(_ delegate: AVServiceDelegate?)
    var currentVolume: Float { get }
    var isMuted: Bool { get }
    func updateMutedStatus(isMuted: Bool)
}

final class AVService: AVServiceAPI {
    private let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    weak var avDelegate: AVServiceDelegate?
    private var cancellable: AnyCancellable?
    var currentVolume: Float = 0
    var isMuted: Bool = true

    init() {
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
            currentVolume = audioSession.outputVolume
            cancellable = audioSession.publisher(for: \.outputVolume)
                .sink { [weak self] newValue in
                    self?.currentVolume = newValue
                    self?.avDelegate?.updateVolume(to: newValue)
                }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    deinit {
        do {
            try audioSession.setActive(false)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    func setDelegate(_ delegate: AVServiceDelegate?) {
        self.avDelegate = delegate
    }

    func updateMutedStatus(isMuted: Bool) {
        self.isMuted = isMuted
    }
}
