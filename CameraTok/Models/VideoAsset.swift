//
//  VideoAsset.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import CoreLocation
import CoreGraphics
import Foundation

struct VideoAsset: Identifiable, Hashable {
    let id: String
    let url: URL
    let thumbnail: CGImage?
    let metatada: Metadata
    var liked: Bool

    init(
        id: String,
        url: URL,
        thumbnail: CGImage? = nil,
        liked: Bool = false,
        metadata: Metadata
    ) {
        self.liked = liked
        self.url = url
        self.thumbnail = thumbnail
        self.id = id
        self.metatada = metadata
    }

    struct Metadata: Equatable, Hashable, Identifiable {
        let id = UUID()
        let location: CLLocation?
        let creationDate: Date?
        let duration: TimeInterval
    }
}
