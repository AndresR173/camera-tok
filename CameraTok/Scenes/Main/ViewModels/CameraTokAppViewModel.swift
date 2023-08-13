//
//  CameraTokAppViewModel.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import Dependencies
import Foundation

enum OnboardingStatus {
    case pending
    case done
}

final class CameraTokAppViewModel: ObservableObject {
    private let isUserOnboarded = "isUserOnboarded"
    @Dependency(\.persistenceService) private var persistence

    @Published var onboardingStatus: OnboardingStatus = .pending

    init() {
        let isUserOnboarded: Bool = persistence.getBool(forKey: isUserOnboarded)
        onboardingStatus = isUserOnboarded ? .done : .pending
    }

    /// Update the shared preference to let the app know that
    /// the onboarding is not longer needed
    func onOnboardingFinished() {
        persistence.set(true, forKey: isUserOnboarded)
        onboardingStatus = .done
    }
}
