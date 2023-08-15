//
//  VideoPlayerView.swift
//  CameraTok
//
//  Created by Andres Rojas on 14/08/23.
//

import AVKit
import SwiftUI

struct VideoPlayerView: View {
    let url: URL
    let videoIndex: Int
    @Binding var currentIndex: Int
    @StateObject private var viewModel = VideoPlayerViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            getPlayer()
        }
        .environmentObject(viewModel)
        .task {
            viewModel.loadVideo(url)
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
                PlayerControlsView()
            }
        } else {
            ProgressView()
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "video_test", withExtension: "mov")!
        VideoPlayerView(url: url, videoIndex: 1,currentIndex: .constant(1))
    }
}
