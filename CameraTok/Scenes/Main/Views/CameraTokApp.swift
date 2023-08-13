//
//  CameraTokApp.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import SwiftUI

@main
struct CameraTokApp: App {
    @StateObject private var viewModel = CameraTokAppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView {
                switch viewModel.onboardingStatus {
                case .pending:
                    OnboardingView()
                case .done:
                    GalleryView()
                }
            }
        }
    }
}
