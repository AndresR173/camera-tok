//
//  ThumbnailView.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import AVFoundation
import Dependencies
import SwiftUI
import Photos

struct ThumbnailView: View {
    let asset: VideoAsset
    @State private var image: UIImage?

    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                thumbnail()
                    .aspectRatio(contentMode: .fit)
                Spacer()
            }
            .frame(
                width: proxy.size.width
            )
            .clipped()
        }
        .aspectRatio(0.5, contentMode: .fit)
        .background(.black)
        .task {
            if let thumbnail = asset.thumbnail {
                image = UIImage(cgImage: thumbnail)
            }
        }
        .onDisappear {
            image = nil
        }
    }

    @ViewBuilder
    func thumbnail() -> some View {
        if let image {
            Image(uiImage: image)
                .resizable()
        } else {
            Image("VideoThumbnail")
                .resizable()
        }
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "video_test", withExtension: "mov")!
        let metadata = VideoAsset.Metadata(
            location: nil,
            creationDate: .now,
            duration: 10_450.0
        )
        ThumbnailView(
            asset: .init(
                id: UUID().uuidString,
                url: url,
                metadata: metadata
            )
        )
    }
}
