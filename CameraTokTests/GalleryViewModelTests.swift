//
//  GalleryViewModelTests.swift
//  CameraTokTests
//
//  Created by Andres Rojas on 14/08/23.
//

@testable
import CameraTok
import XCTest
import Dependencies

@MainActor
final class GalleryViewModelTests: XCTestCase {
    var mockGalleryService: GalleryServiceDependencyKey.MockGalleryService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockGalleryService = GalleryServiceDependencyKey.MockGalleryService()
    }
}

extension GalleryViewModelTests {
    func testInitialState() async throws {
        let sut = GalleryViewModel()
        XCTAssertEqual(sut.viewStatus, SceneStatus.loading)
    }

    func testServiceError() async throws {
        mockGalleryService.error = GalleryServiceError.assetNotFound
        let sut = withDependencies({
            $0.galleryService = mockGalleryService
        }, operation: {
            GalleryViewModel()
        })

        await sut.refreshGallery()
        XCTAssertEqual(sut.viewStatus, .error(NSLocalizedString("error.asset_not_found", comment: "")))

        mockGalleryService.error = NSError(domain: "", code: 0)

        await sut.refreshGallery()
        XCTAssertEqual(sut.viewStatus, .error(NSLocalizedString("error.generic", comment: "")))
    }

    func testGalleryServiceSuccess() async throws {
        let sut = withDependencies {
            $0.galleryService = GalleryServiceDependencyKey.MockGalleryService()
        } operation: {
            GalleryViewModel()
        }
        await sut.refreshGallery()
        XCTAssertEqual(sut.viewStatus, .loaded)
    }

    func testRefreshGallery() async throws {
        mockGalleryService.authorizationStatus = .notDetermined
        mockGalleryService.response = []
        let sut = withDependencies {
            $0.galleryService = mockGalleryService
        } operation: {
            GalleryViewModel()
        }
        await sut.refreshGallery()

        XCTAssertTrue(mockGalleryService.validateAuthorizationCalled)
        XCTAssertEqual(sut.viewStatus, .empty)
    }
}
