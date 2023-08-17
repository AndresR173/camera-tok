//
//  SceneStatus.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import Foundation

enum SceneStatus: Equatable {
    case loading
    case loaded
    case empty
    case error(EmptyStates)
}
