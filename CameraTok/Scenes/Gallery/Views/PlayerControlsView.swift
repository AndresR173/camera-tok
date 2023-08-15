//
//  PlaverControlsView.swift
//  CameraTok
//
//  Created by Andres Rojas on 15/08/23.
//

import AVKit
import SwiftUI

struct PlayerControlsView : View {
    @EnvironmentObject var viewModel: VideoPlayerViewModel
    @GestureState private var translation: CGFloat = 0

    var body: some View {
        VStack {
            Color.clear
            HStack {
                ControlButton(
                    image: viewModel.isMuted ? "speaker.slash.fill" : "speaker.fill"
                ) {
                    self.viewModel.toggleVolume()
                }
                .padding(.leading, 24)
                ControlButton(
                    image: viewModel.isPlayerPaused ? "play.fill" : "pause.fill"
                ) {
                    self.viewModel.toogleVideoPlayback()
                }
                .padding(.horizontal, 8)
                CustomSlider(percentage: $viewModel.seekPos) {
                    guard let item = self.viewModel.currentItem else {
                        return
                    }
                    let targetTime = viewModel.seekPos * item.duration.seconds
                    
                    self.viewModel.seek(
                        to: CMTime(seconds: targetTime, preferredTimescale: 600)
                    )
                }
                .padding(.trailing, 20)
            }
        }
        .padding(.bottom, 48)
    }
}

struct PlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        let url = Bundle.main.url(forResource: "video_test", withExtension: "mov")!
        let viewModel = VideoPlayerViewModel()

        return PlayerControlsView()
            .environmentObject(viewModel)
            .task {
                viewModel.loadVideo(url)
            }
    }
}
