//
//  CameraTokAppViewModelTests.swift
//  CameraTokTests
//
//  Created by Andres Rojas on 13/08/23.
//

@testable
import CameraTok
import XCTest
import Dependencies

@MainActor
final class CameraTokAppViewModelTests: XCTestCase {
     func testInitialOnboardedStatus() async throws {
        let sut = CameraTokAppViewModel()
        XCTAssertEqual(sut.onboardingStatus, .pending)

        await sut.onOnboardingFinished()
        XCTAssertEqual(sut.onboardingStatus, .done)
    }

    func testInitialOnboardedStatusDone() async throws {
        let mockPersistence = PersistenceServiceDependencyKey.MockPersistenceService()
        mockPersistence.set(true, forKey: "isUserOnboarded")
        let sut = withDependencies({
            $0.persistenceService = mockPersistence
        }, operation: {
            CameraTokAppViewModel()
        })
        XCTAssertEqual(sut.onboardingStatus, .done)
    }
}
