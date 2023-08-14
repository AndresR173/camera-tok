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
    @Dependency(\.persistenceService) private var persistenceService
    @Dependency(\.galleryService) private var galleryService

    @Published var onboardingStatus: OnboardingStatus = .pending

    init() {
        let isUserOnboarded: Bool = persistenceService.getBool(forKey: isUserOnboarded)
        onboardingStatus = isUserOnboarded ? .done : .pending
    }

    /// Update the shared preference to let the app know that
    /// the onboarding is not longer needed
    func onOnboardingFinished() {
        galleryService.requestAuthorization() { [weak self] in
            guard let self else { return }
            self.persistenceService.set(true, forKey: self.isUserOnboarded)
            DispatchQueue.main.async {
                self.onboardingStatus = .done
            }
        }
    }
}
