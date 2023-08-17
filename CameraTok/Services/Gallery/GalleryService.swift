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
    func fetchVideos(from date: Date) async throws -> [VideoAsset]
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
    @UserDefaultsWrapper(key: "likedAssets", defaultValue: [:])
    var likedAssets: [String: Bool]

    func requestAuthorization() async {
        await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                self?.phAuthorizationStatus = status
                continuation.resume()
            }
        }
    }

    func validateAuthorizationStatus() async -> PHAuthorizationStatus {
        phAuthorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        return phAuthorizationStatus
    }

    func fetchVideos(from date: Date)  async throws -> [VideoAsset] {
        switch await validateAuthorizationStatus() {
        case .authorized, .limited:
            let fetchOptions = PHFetchOptions()
            fetchOptions.includeHiddenAssets = false
            fetchOptions.fetchLimit = 15
            let datePredicate = NSPredicate(format: "creationDate < %@", date as NSDate)
            fetchOptions.predicate = datePredicate
            fetchOptions.sortDescriptors = [
                NSSortDescriptor(key: "creationDate", ascending: false)
            ]
            let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
            var phAssets: [PHAsset] = []
            fetchResult.enumerateObjects { asset, index, stop in
                phAssets.append(asset)
            }

            var assets: [VideoAsset] = []
            for asset in phAssets {
                if let url = await getAssetURL(asset) {
                    let image = generateThumbnail(forURL: url)
                    let liked = likedAssets[asset.localIdentifier] ?? false

                    let metadata = VideoAsset.Metadata(
                        location: asset.location,
                        creationDate: asset.creationDate,
                        duration: asset.duration
                    )
                    assets.append(
                        VideoAsset(
                            id: asset.localIdentifier,
                            url: url,
                            thumbnail: image,
                            liked: liked,
                            metadata: metadata
                        )
                    )
                }
            }

            return assets
        default:
            throw GalleryServiceError.permissionsRequired
        }
    }

    private func generateThumbnail(forURL url: URL) -> CGImage? {
        let url = url
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            return thumbnailImage
        } catch {
            return nil
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
