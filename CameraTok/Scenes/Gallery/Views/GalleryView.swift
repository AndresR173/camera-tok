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
        galleryView()
        .padding(.horizontal)
        .task {
            await viewModel.refreshGallery()
        }
    }

    @ViewBuilder
    func galleryView() -> some View {
        switch viewModel.viewStatus {
        case .loaded:
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
        case .loading:
            ProgressView()
        case .error(let error):
            Text(error)
        case .empty:
            Text("empty")
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
