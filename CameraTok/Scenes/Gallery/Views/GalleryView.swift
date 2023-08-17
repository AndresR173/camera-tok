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
    @State private var isDatePickerVisible = false
    @State private var pickerBackgroundColor = Color.clear
    @State private var selectedDate: Date = .now

    var body: some View {
        ZStack(alignment: .top) {
            buildGalleryView()
                .task {
                    await viewModel.refreshGallery()
            }
            if viewModel.viewStatus == .loaded {
                filter
            }
        }
    }

    @ViewBuilder
    func buildGalleryView() -> some View {
        switch viewModel.viewStatus {
        case .loaded:
            galleryView
        case .loading:
            ProgressView()
        case .error(let state):
            if state == .permissions {
                EmptyState(
                    emptyState: .permissions,
                    ctaTitle: NSLocalizedString("cta.go_to_settings", comment: "")
                ) {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url)
                }
            } else {
                EmptyState(emptyState: state)
            }

        case .empty:
            EmptyState(emptyState: .empty)
        }
    }
}

extension GalleryView {
    var filter: some View {
        VStack {
            HStack {
                Spacer()
                Text(isDatePickerVisible ? LocalizedStringKey("done") : LocalizedStringKey("filter"))
                    .font(.app(.medium, size: 18))
                    .foregroundColor(.white)
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            isDatePickerVisible.toggle()
                            pickerBackgroundColor = isDatePickerVisible ? Color("AppBackgroundColor") : .clear
                        }
                    }
                    .padding(.horizontal , 8)
                    .padding(.vertical, 4)
                    .background(isDatePickerVisible ? .clear : .black.opacity(0.4))
                    .cornerRadius(7)
            }
            if isDatePickerVisible {
                DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .labelsHidden()
            }
        }
        .onChange(of: selectedDate) { newDate in
            Task {
                await viewModel.updateGallery(newDate)
            }
        }
        .background(pickerBackgroundColor)
        .cornerRadius(7)
        .padding(.all)

    }

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
