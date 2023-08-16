//
//  VideoAsset.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import CoreGraphics
import Foundation

struct VideoAsset: Identifiable, Hashable {
    let id: String
    let url: URL
    let thumbnail: CGImage?
    var liked: Bool

    init(id: String, url: URL, thumbnail: CGImage? = nil, liked: Bool = false) {
        self.liked = liked
        self.url = url
        self.thumbnail = thumbnail
        self.id = id
    }
}
