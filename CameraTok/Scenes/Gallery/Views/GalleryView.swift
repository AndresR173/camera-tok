//
//  GalleryView.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import SwiftUI

struct GalleryView: View {
    @StateObject private var viewModel = GalleryViewModel()

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(
                columns: Array(
                    repeating: .init(.adaptive(minimum: 100), spacing: 8),
                    count: 3),
                alignment: .center,
                spacing: 8
            ) {
                ForEach(viewModel.gallery, id: \.self) { asset in
                    ThumbnailView(id: asset)
                }
            }
        }
        .padding(.horizontal)
        .task {
            await viewModel.refreshGallery()
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
