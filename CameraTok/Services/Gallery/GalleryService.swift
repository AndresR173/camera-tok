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
    func fetchVideos() async throws -> [VideoAsset]
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
    private var assets: [VideoAsset] = []

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

    func fetchVideos()  async throws -> [VideoAsset] {
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
            var phAssets: [PHAsset] = []
            fetchResult.enumerateObjects { asset, index, stop in
                phAssets.append(asset)
            }
            var urls: [URL?] = []
            for asset in phAssets {
                let url = await getAssetURL(asset)
                urls.append(url)
            }
            let newAssets: [VideoAsset] = urls.compactMap {
                guard let url = $0 else { return nil }
                return VideoAsset(url: url)
            }
            assets.append(contentsOf: newAssets)
            return assets
        default:
            throw GalleryServiceError.permissionsRequired
        }

    }

    private func getAssetURL(_ asset: PHAsset) async -> URL? {
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
    }
}
