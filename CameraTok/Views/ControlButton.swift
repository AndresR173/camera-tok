//
//  ControlButton.swift
//  CameraTok
//
//  Created by Andres Rojas on 15/08/23.
//

import SwiftUI

struct ControlButton: View {
    let image: String
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
        }
    }
}

struct ControlButton_Previews: PreviewProvider {
    static var previews: some View {
        ControlButton(image: "speaker") {}
    }
}
