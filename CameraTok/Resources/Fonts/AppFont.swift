//
//  AppFont.swift
//  BudgetMe
//
//  Created by Andres Rojas on 17/06/23.
//

import Foundation
import SwiftUI

enum AppFont: String {
    case bold = "Manrope-Bold"
    case light = "Manrope-Light"
    case medium = "Manrope-Medium"
    case regular = "Manrope-Regular"
    case semiBold = "Manrope-SemiBold"
}

extension Font {
    static func app (_ font: AppFont, size: CGFloat) -> Font {
        Font.custom(font.rawValue, size: size)
    }
}
