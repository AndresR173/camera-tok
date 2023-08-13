//
//  PrimaryButton.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import SwiftUI

struct PrimaryButton: View {
    @State var isEnabled: Bool = true
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(Color("AccentColor"))
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .cornerRadius(15.0)
                Text(title)
                    .font(.app(.bold, size: 14))
                    .foregroundColor(.white)
            }
        }
        .disabled(!isEnabled)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "Test") {}
    }
}
