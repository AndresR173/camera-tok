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

    var gallery: [UUID] = []
    @Published var viewStatus: SceneStatus = .loading

    func refreshGallery() async {
        do {
            gallery = try await galleryService.fetchVideos()
            viewStatus = gallery.isEmpty ? .empty : .loaded
        } catch {
            if let error = error as? GalleryServiceError {
                viewStatus = .error(error.localizedDescription)
            } else {
                viewStatus = .error(NSLocalizedString("error.generic", comment: ""))
            }
        }
    }

    func fetchVideoURL(_ id: UUID) async -> URL? {
        await galleryService.fetchVideoThumbnail(id)
    }
}
