//
//  IntroOboardingView.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import SwiftUI

struct IntroOboardingView: View {
    var body: some View {
        VStack {
            LottieView(lottieFile: Animations.camera)
                .frame(height: 300)
            Text(LocalizedStringKey("onboarding.intro"))
                .font(.app(.bold, size: 14))
                .tag(0)
        }
    }
}

struct IntroOboardingView_Previews: PreviewProvider {
    static var previews: some View {
        IntroOboardingView()
    }
}
