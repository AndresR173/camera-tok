//
//  VideoAsset.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import CoreGraphics
import Foundation

struct VideoAsset: Identifiable, Hashable {
    let id: UUID
    let url: URL
    let thumbnail: CGImage?

    init(url: URL, thumbnail: CGImage?) {
        self.url = url
        self.thumbnail = thumbnail
        self.id = UUID()
    }
}
