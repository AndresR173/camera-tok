//
//  GalleryService+Dependencies.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import Dependencies
import Foundation

enum GalleryServiceDependencyKey: DependencyKey {
    static let liveValue: GalleryServiceApi = GalleryService()
    static let previewValue: GalleryServiceApi = MockGalleryService()
    static let testValue: GalleryServiceApi = MockGalleryService()

    class MockGalleryService: GalleryServiceApi {
        var authorizationStatus: GalleryAuthorizationStatus = .authorized

        func requestAuthorization(onAuthorizationRequested: () -> Void) {
            onAuthorizationRequested()
        }
    }
}

extension DependencyValues {
    var galleryService: GalleryServiceApi {
        get { self[GalleryServiceDependencyKey.self] }
        set { self[GalleryServiceDependencyKey.self] = newValue }
    }
}
