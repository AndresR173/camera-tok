//
//  AVPlayerGenerator.swift
//  CameraTok
//
//  Created by Andres Rojas on 16/08/23.
//

import AVKit
import Foundation

public struct AVPlayerGenerator: Sendable {
  private let generate: @Sendable () -> AVPlayer

  public init(_ generate: @escaping @Sendable () -> AVPlayer) {
    self.generate = generate
  }

  public func callAsFunction() -> AVPlayer {
    self.generate()
  }
}
