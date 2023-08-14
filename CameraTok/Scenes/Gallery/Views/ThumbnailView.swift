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
    let id: UUID
    @State private var image: UIImage?
    @Dependency(\.galleryService) private var service

    var body: some View {
        GeometryReader { proxy in
            thumbnail()
                .frame(
                    width: proxy.size.width
                )
                .clipped()
        }
        .aspectRatio(0.5, contentMode: .fit)
        .task {
            if let url = await service.fetchVideoThumbnail(id) {
                let asset: AVAsset = AVAsset(url: url)
                let imageGenerator = AVAssetImageGenerator(asset: asset)

                do {
                    let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
                    image = UIImage(cgImage: thumbnailImage)
                } catch {
                    image = nil
                }
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
        ThumbnailView(id: UUID())
    }
}
