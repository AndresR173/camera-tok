//
//  VSpacer.swift
//  CameraTok
//
//  Created by Andres Rojas on 16/08/23.
//

import SwiftUI

struct VSpacer: View {
    let height: CGFloat

    init(_ height: CGFloat = 8) {
        self.height = height
    }

    var body: some View {
        Spacer()
            .frame(height: height)
    }
}

struct VSpacer_Previews: PreviewProvider {
    static var previews: some View {
        VSpacer(24)
    }
}
