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
        var mockURL: URL? = nil
        var error: GalleryServiceError? = nil

        func fetchVideos() async throws -> [UUID] {
            if let error {
                throw error
            } else {

                return Array(repeating: (), count: 10).map { UUID() }
            }
        }

        func requestAuthorization() async {
            await withCheckedContinuation { continuation in
                continuation.resume()
            }
        }

        func fetchVideoThumbnail(_ id: UUID) async -> URL? {
            mockURL
        }
    }
}

extension DependencyValues {
    var galleryService: GalleryServiceApi {
        get { self[GalleryServiceDependencyKey.self] }
        set { self[GalleryServiceDependencyKey.self] = newValue }
    }
}
