//
//  ThumbnailView.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import AVKit
import Dependencies
import SwiftUI
import Photos

struct ThumbnailView: View {
    let id: UUID
    @State private var url: URL?
    @Dependency(\.galleryService) private var service

    var body: some View {
        GeometryReader { proxy in
            thumbnail()
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.width
                )
                .clipped()
        }
        .aspectRatio(1, contentMode: .fit)
        .task {
            url = await service.fetchVideoThumbnail(id)
        }
        .onDisappear {
            url = nil
        }
    }

    @ViewBuilder
    func thumbnail() -> some View {
        if let videoURL = url {
        VideoPlayer(player: AVPlayer(url: videoURL))
            .aspectRatio(1, contentMode: .fit)
        } else {
            Image("VideoThumbnail")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        ThumbnailView(id: UUID())
    }
}
