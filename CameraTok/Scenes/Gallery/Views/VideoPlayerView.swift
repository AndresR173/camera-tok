//
//  VideoPlayerView.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import AVKit
import SwiftUI

struct VideoPlayerView: View {
    @Binding var asset: VideoAsset
    let videoIndex: Int
    @Binding var currentIndex: Int
    @StateObject private var viewModel = VideoPlayerViewModel()
    @State private var showingSheet = false
    @State private var sheetHeight: CGFloat = .zero
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            getPlayer()
        }
        .environmentObject(viewModel)
        .task {
            dump(asset.liked)
            viewModel.loadVideo(asset.url)
        }
    }

    @ViewBuilder
    func getPlayer() -> some View {
        if let player = viewModel.player {
            ZStack {
                VideoPlayer(player: player)
                    .disabled(true)
                    .onDisappear {
                        viewModel.stop()
                    }
                    .onAppear {
                        if currentIndex == videoIndex {
                            viewModel.play()
                        }
                    }
                    .onChange(of: $currentIndex.wrappedValue, perform: { newValue in
                        if newValue == videoIndex && viewModel.isPlayerPaused {
                            viewModel.play()
                        } else {
                            viewModel.stop()
                        }
                    })
                HStack {
                    Spacer()
                    VStack {
                        LikeButton(isLiked: $asset.liked) {
                            asset.liked.toggle()
                            viewModel.changeLikeStatus(for: asset)
                        }
                            .frame(width: 24, height:  24)
                        VSpacer(16)
                        ControlButton(
                            image: showingSheet ? "info.circle.fill" : "info.circle"
                        ) {
                            withAnimation {
                                showingSheet.toggle()
                            }
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.trailing, 8)
                PlayerControlsView()
            }
            .sheet(isPresented: $showingSheet) {
                VideoMetadataView(metadata: asset.metatada)
                    .padding()
                    .overlay {
                        GeometryReader { geometry in
                            Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                        }
                    }
                    .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                        sheetHeight = newHeight
                    }
                    .presentationDetents([.height(sheetHeight)])
            }
        } else {
            ProgressView()
        }
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "video_test", withExtension: "mov")!
        let metadata = VideoAsset.Metadata(
            location: nil,
            creationDate: .now,
            duration: 10_450.0
        )
        VideoPlayerView(
            asset: .constant(.init(
                id: UUID().uuidString,
                url: url,
                metadata: metadata
            )),
            videoIndex: 1,
            currentIndex: .constant(1)
        )
    }
}
