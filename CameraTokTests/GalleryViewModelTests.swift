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

    func testInitialState() async throws {
        let sut = GalleryViewModel()
        XCTAssertEqual(sut.viewStatus, SceneStatus.loading)
    }

    func testServiceError() async throws {
        mockGalleryService.error = .assetNotFound
        let sut = withDependencies({
            $0.galleryService = mockGalleryService
        }, operation: {
            GalleryViewModel()
        })
        await sut.refreshGallery()
        XCTAssertEqual(sut.viewStatus, .error(NSLocalizedString("error.asset_not_found", comment: "")))
    }

    func testGalleryServiceSuccess() async throws {
        let sut = withDependencies {
            $0.galleryService = GalleryServiceDependencyKey.MockGalleryService()
            $0.uuid = .incrementing
        } operation: {
            GalleryViewModel()
        }
        await sut.refreshGallery()
        XCTAssertEqual(sut.viewStatus, .loaded)
    }
}
