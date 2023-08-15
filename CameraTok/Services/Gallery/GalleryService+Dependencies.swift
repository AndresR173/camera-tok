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
        var authorizationStatus: GalleryAuthorizationStatus = .authorized
        var error: GalleryServiceError? = nil

        func fetchVideos() async throws -> [VideoAsset] {
            if let error {
                throw error
            } else {
                let url = Bundle.main.url(forResource: "video_test", withExtension: "mov")!
                return Array(repeating: (), count: 10).map { .init(url: url, thumbnail: nil) }
            }
        }

        func requestAuthorization() async {}

        func validateAuthorizationStatus() async {}

    }
}

extension DependencyValues {
    var galleryService: GalleryServiceApi {
        get { self[GalleryServiceDependencyKey.self] }
        set { self[GalleryServiceDependencyKey.self] = newValue }
    }
}
