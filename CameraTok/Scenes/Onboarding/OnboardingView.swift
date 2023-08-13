//
//  OnboardingView.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentTab = 0

    var body: some View {
        TabView(selection: $currentTab,
                content:  {
            IntroOboardingView()
                .tag(0)
            GalleryOnboardingView()
                .padding(.bottom, 48)
                .tag(1)
        })
        .padding()
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
