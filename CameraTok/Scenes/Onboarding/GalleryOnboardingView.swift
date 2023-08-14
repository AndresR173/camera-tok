//
//  GalleryOnboardingView.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import SwiftUI

struct GalleryOnboardingView: View {
    var onRequestAccess: () -> Void

    var body: some View {
        VStack {
            LottieView(lottieFile: Animations.gallery)
                .frame(height: 300)
            Spacer()
                .frame(height: 32)
            Text(LocalizedStringKey("onboarding.gallery"))
                .font(.app(.bold, size: 14))
                .tag(0)
            Spacer()
            PrimaryButton(title: NSLocalizedString("onboarding.grant_access", comment: "")) {
                onRequestAccess()
            }
            .padding(.horizontal, 32)
        }
    }
}

struct GalleryOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryOnboardingView() {}
    }
}
