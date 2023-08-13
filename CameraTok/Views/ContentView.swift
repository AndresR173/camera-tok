//
//  ContentView.swift
//  CameraTok
//
//  Created by Andres Rojas on 13/08/23.
//

import SwiftUI

struct ContentView<Content: View>: View {

    let content: Content

    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("AppBackgroundColor"))
    }
}
