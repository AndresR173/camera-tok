//
//  GalleryService.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import Foundation
import Photos

enum GalleryAuthorizationStatus {
    case notDetermined
    case granted
    case authorized
    case limited
    case denied
}

protocol GalleryServiceApi {
    var authorizationStatus: GalleryAuthorizationStatus { get async }
    func requestAuthorization() async
}

@MainActor
final class GalleryService: GalleryServiceApi {
    nonisolated var authorizationStatus: GalleryAuthorizationStatus {
        get async {
            switch await _authorizationStatus {
            case .notDetermined:
                return .notDetermined
            case .denied, .restricted:
                return .denied
            case .authorized:
                return .authorized
            case .limited:
                return .limited
            @unknown default:
                return .denied
            }
        }
    }
    private var _authorizationStatus: PHAuthorizationStatus = .notDetermined

    func requestAuthorization() async {
        await withCheckedContinuation { [weak self] continuation in
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                self?._authorizationStatus = status
                continuation.resume()
            }
        }
    }
}
