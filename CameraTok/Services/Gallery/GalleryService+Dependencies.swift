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
        private let url = Bundle.main.url(forResource: "video_test", withExtension: "mov")!


        var authorizationStatus: GalleryAuthorizationStatus = .authorized
        var error: Error? = nil
        var validateAuthorizationCalled = false
        var requestAuhtorizationCalled = false

        let metadata = VideoAsset.Metadata(
            location: nil,
            creationDate: .now,
            duration: 10_450.0
        )
        lazy var response: [VideoAsset] = Array(repeating: (), count: 10).map { .init(id: UUID().uuidString, url: url, metadata: metadata) }

        func fetchVideos(from date: Date) async throws -> [VideoAsset] {
            if let error {
                throw error
            } else {
                return response
            }
        }

        func requestAuthorization() async {
            requestAuhtorizationCalled = true
        }

        func validateAuthorizationStatus() async {
            validateAuthorizationCalled = true
        }
    }
}

extension DependencyValues {
    var galleryService: GalleryServiceApi {
        get { self[GalleryServiceDependencyKey.self] }
        set { self[GalleryServiceDependencyKey.self] = newValue }
    }
}
