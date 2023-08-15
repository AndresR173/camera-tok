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
    @StateObject private var viewModel = VideoPlayerViewModel()
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            getPlayer()
        }
        .task {
            viewModel.loadVideo(url)
        }
    }

    @ViewBuilder
    func getPlayer() -> some View {
        if let player = viewModel.player {
            VideoPlayer(player: player)
                .onTapGesture {
                    viewModel.toggleVolume()
                }
                .onAppear {
                    viewModel.play()
                }
                .onDisappear {
                    viewModel.pause()
                }
        } else {
            ProgressView()
        }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "video_test", withExtension: "mov")!
        VideoPlayerView(url: url)
    }
}
