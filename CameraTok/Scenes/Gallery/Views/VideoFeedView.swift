//
//  VideoFeed.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import SwiftUI

struct VideoFeedView: View {
    @Environment(\.dismiss) var dismiss
    let videos: [VideoAsset]
    private var pageCount: Int {
        videos.count
    }
    @GestureState private var translation: CGFloat = 0
    @State var currentIndex: Int

    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(videos.enumerated()), id: \.offset) { index, video in
                        VideoPlayerView(
                            asset: video,
                            videoIndex: index,
                            currentIndex: $currentIndex
                        )
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                    }
                }
                .background(.black)
                .offset(y: -CGFloat(self.currentIndex) * geometry.size.height)
                .offset(y: self.translation)
                .animation(.interactiveSpring(response: 0.3), value: currentIndex)
                .animation(.interactiveSpring(), value: translation)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .updating(self.$translation) { value, state, _ in
                            state = value.translation.height
                        }
                        .onEnded { value in
                            let offset = -Int(value.translation.height)
                            if abs(offset) > 20 {
                                let newIndex = currentIndex + min(max(offset, -1), 1)
                                if newIndex >= 0 && newIndex < pageCount {
                                    self.currentIndex = newIndex
                                }
                            }
                        }
                )
            }
            .environment(\.isScrollEnabled, false)
        }
        .edgesIgnoringSafeArea(.all)
        .background(.black)
        .overlay {
            toolbarView
        }
    }
}

extension VideoFeedView {
    var toolbarView: some View {
        HStack {
            Spacer()
            VStack {
                closeButton
                Spacer()
            }
        }
    }

    var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: 16, height: 16)
                .padding(.all, 12)
                .background(.ultraThinMaterial, in: Circle())
        }
    }
}

struct VideoFeed_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "video_test", withExtension: "mov")!
        VideoFeedView(videos: [
            .init(id: UUID().uuidString, url: url),
            .init(id: UUID().uuidString, url: url)
        ], currentIndex: 0)
    }
}
