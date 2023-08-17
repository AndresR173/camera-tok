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
    private var filterDate: Date = .now
    private var canLoadMore = true

    func refreshGallery() async {
        if await galleryService.authorizationStatus == .notDetermined {
            await galleryService.validateAuthorizationStatus()
        }
        do {
            let videos = try await galleryService.fetchVideos(from: filterDate)
            canLoadMore = videos.count >= 15
            self.videos.append(contentsOf: videos)
            if let lastVideo = videos.last {
                filterDate = lastVideo.metatada.creationDate ?? .now
            }
            viewStatus = self.videos.isEmpty ? .empty : .loaded
        } catch {
            if let error = error as? GalleryServiceError {
                viewStatus = .error(error.localizedDescription)
            } else {
                viewStatus = .error(NSLocalizedString("error.generic", comment: ""))
            }
        }
    }

    func loadVideosIfNeeded(index: Int) async {
        guard index == videos.count - 1, canLoadMore else {
            return
        }
        await refreshGallery()
    }
}
