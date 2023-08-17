//
//  EmptyState.swift
//  CameraTok
//
//  Created by Andres Rojas on 16/08/23.
//

import SwiftUI

struct EmptyState: View {
    let emptyState: EmptyStates
    let ctaTitle: String
    let onTapCTA: (() -> Void)?

    init(
        emptyState: EmptyStates,
        ctaTitle: String = "",
        onTapCTA: (() -> Void)? = nil
    ) {
        self.emptyState = emptyState
        self.ctaTitle = ctaTitle
        self.onTapCTA = onTapCTA
    }

    var body: some View {
        VStack {
            LottieView(lottieFile: emptyState.animation)
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            VSpacer(32)
            Text(emptyState.caption)
                .font(.app(.bold, size: 14))
                .tag(0)
            if let onTapCTA {
                VSpacer(24)
                PrimaryButton(title: ctaTitle, action: onTapCTA)
            }
        }
        .padding()
    }
}

struct EmptyState_Previews: PreviewProvider {
    static var previews: some View {
        EmptyState(emptyState: .permissions, ctaTitle: "Go to settings") {

        }
    }
}
