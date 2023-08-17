//
//  GalleryView.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()
    @State private var videoAsset: VideoAsset? = nil

    var body: some View {
        buildGalleryView()
            .task {
                await viewModel.refreshGallery()
            }
    }

    @ViewBuilder
    func buildGalleryView() -> some View {
        switch viewModel.viewStatus {
        case .loaded:
            galleryView
        case .loading:
            ProgressView()
        case .error(let error):
            Text(error)
        case .empty:
            Text("empty")
        }
    }
}

extension GalleryView {
    var galleryView: some View {
        ScrollView(.vertical) {
            LazyVGrid(
                columns: Array(
                    repeating: .init(.adaptive(minimum: 100), spacing: 0),
                    count: 3),
                alignment: .center,
                spacing: 0
            ) {
                ForEach(Array($viewModel.videos.enumerated()), id: \.offset) { index, $asset in
                    ThumbnailView(asset: asset)
                        .onTapGesture {
                            videoAsset = asset
                        }.onAppear {
                            Task {
                                await viewModel.loadVideosIfNeeded(index: index)
                            }
                        }
                }

            }
            .fullScreenCover(item: $videoAsset) { asset in
                VideoFeedView(
                    videos: $viewModel.videos,
                    currentIndex: viewModel.videos.firstIndex(where: { $0.id == asset.id }) ?? 0
                )
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
