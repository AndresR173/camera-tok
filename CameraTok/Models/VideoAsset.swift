//
//  VideoAsset.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import Foundation

struct VideoAsset: Identifiable, Hashable {
    let id: UUID
    var url: URL

    init(url: URL) {
        self.url = url
        self.id = UUID()
    }
}
