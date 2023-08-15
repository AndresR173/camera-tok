//
//  GalleryViewModel.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import Dependencies
import Foundation

@MainActor
final class GalleryViewModel: ObservableObject {
    @Dependency(\.galleryService) private var galleryService

    @Published var videos: [VideoAsset] = []
    @Published var viewStatus: SceneStatus = .loading

    func refreshGallery() async {
        if await galleryService.authorizationStatus == .notDetermined {
            await galleryService.validateAuthorizationStatus()
        }
        do {
            videos = try await galleryService.fetchVideos()
            viewStatus = videos.isEmpty ? .empty : .loaded
        } catch {
            if let error = error as? GalleryServiceError {
                viewStatus = .error(error.localizedDescription)
            } else {
                viewStatus = .error(NSLocalizedString("error.generic", comment: ""))
            }
        }
    }
}
