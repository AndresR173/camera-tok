//
//  GalleryService.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import Dependencies
import Foundation
import Photos

enum GalleryServiceError: LocalizedError {
    case assetNotFound
    case permissionsRequired
    case generic

    var errorDescription: String? {
        switch self {
        case .assetNotFound:
            return NSLocalizedString("error.asset_not_found", comment: "")
        case .permissionsRequired:
            return NSLocalizedString("error.permissions_required", comment: "")
        case .generic:
            return NSLocalizedString("error.generic", comment: "")
        }
    }
}

protocol GalleryServiceApi {
    var authorizationStatus: GalleryAuthorizationStatus { get async }
    func requestAuthorization() async
    func fetchVideos() async throws -> [UUID]
    func fetchVideoThumbnail(_ id: UUID) async -> URL?
    func validateAuthorizationStatus() async
}

@MainActor
final class GalleryService: GalleryServiceApi {
    nonisolated var authorizationStatus: GalleryAuthorizationStatus {
        get async {
            switch await phAuthorizationStatus {
            case .notDetermined:
                return .notDetermined
            case .denied, .restricted:
                return .denied
            case .authorized:
                return .authorized
            case .limited:
                return .limited
            @unknown default:
                return .denied
            }
        }
    }
    private var phAuthorizationStatus: PHAuthorizationStatus = .notDetermined
    private var assets: [UUID: PHAsset] = [:]

    func requestAuthorization() async {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                self?.phAuthorizationStatus = status
                continuation.resume()
            }
        }
    }

    func validateAuthorizationStatus() async {
        phAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .addOnly)
    }

    func fetchVideos()  async throws -> [UUID] {
        switch await authorizationStatus {
        case .authorized, .limited:
            @Dependency(\.uuid) var uuid

            let fetchOptions = PHFetchOptions()
            fetchOptions.includeHiddenAssets = false
            fetchOptions.fetchLimit = 15
            fetchOptions.sortDescriptors = [
                NSSortDescriptor(key: "creationDate", ascending: false)
            ]
            let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
            fetchResult.enumerateObjects {[weak self] asset, index, stop in
                guard let self else { return }
                self.assets[uuid()] = asset
            }

            return assets.keys.map { $0 }
        default:
            throw GalleryServiceError.permissionsRequired
        }

    }

    func fetchVideoThumbnail(_ id: UUID) async -> URL? {
        if let asset = assets[id] {
            return await withCheckedContinuation { continuation in
                let options: PHVideoRequestOptions = PHVideoRequestOptions()
                options.version = .original
                PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { asset, audioMix, info  in
                    if let urlAsset = asset as? AVURLAsset {
                        let localVideoUrl: URL = urlAsset.url as URL
                        continuation.resume(returning: localVideoUrl)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
        } else {
            return nil
        }
    }
}
