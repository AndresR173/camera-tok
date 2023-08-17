//
//  EmptyStates.swift
//  CameraTok
//
//  Created by Andres Rojas on 16/08/23.
//

import Foundation

enum EmptyStates {
    case error
    case empty
    case permissions

    var caption: String {
        switch self {
        case .error:
            return NSLocalizedString("error.generic", comment: "")
        case .empty:
            return NSLocalizedString("error.assets_not_found", comment: "")
        case .permissions:
            return NSLocalizedString("error.permissions_required", comment: "")
        }
    }

    var animation: String {
        switch self {
        case .error:
            return "error_animation"
        case .empty:
            return "empty_animation"
        case .permissions:
            return "permissions_animation"
        }
    }
}
