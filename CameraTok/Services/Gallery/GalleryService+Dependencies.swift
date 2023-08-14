//
//  GalleryService+Dependencies.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import Dependencies
import Foundation

@MainActor
enum GalleryServiceDependencyKey: DependencyKey {
    static let liveValue: GalleryServiceApi = GalleryService()
    static let previewValue: GalleryServiceApi = MockGalleryService()
    static let testValue: GalleryServiceApi = MockGalleryService()

    class MockGalleryService: GalleryServiceApi {
        func requestAuthorization() async {
            await withCheckedContinuation { continuation in
                continuation.resume()
            }
        }

        var authorizationStatus: GalleryAuthorizationStatus = .authorized
    }
}

extension DependencyValues {
    var galleryService: GalleryServiceApi {
        get { self[GalleryServiceDependencyKey.self] }
        set { self[GalleryServiceDependencyKey.self] = newValue }
    }
}
