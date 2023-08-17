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
    private var initialdate: Date = .now
    private var canLoadMore = true

    func refreshGallery() async {
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
                switch error {
                case .assetNotFound:
                    viewStatus = .error(.empty)
                case .permissionsRequired:
                    viewStatus = .error(.permissions)
                case .generic:
                    viewStatus = .error(.error)
                }
            } else {
                viewStatus = .error(.error)
            }
        }
    }

    func loadVideosIfNeeded(index: Int) async {
        guard index == videos.count - 1, canLoadMore else {
            return
        }
        await refreshGallery()
    }

    func updateGallery(_ date: Date) async {
        guard date != initialdate else { return }
        filterDate = date
        initialdate = date
        videos.removeAll()
        viewStatus = .loading
        await refreshGallery()
    }
}
