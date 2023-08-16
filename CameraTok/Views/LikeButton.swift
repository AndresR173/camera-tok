//
//  LikeButton.swift
//  CameraTok
//
//  Created by Andres Rojas on 15/08/23.
//

import SwiftUI

struct LikeButton: View {
    @State private var opacity = 0.0
    @State private var scale = 0.0
    @State private var color: Color = .white

    @Binding var isLiked: Bool
    var onPressed: () -> Void

    var body: some View {
        ZStack {
            Image(systemName: "heart.fill")
                .resizable()
                .opacity(opacity)
                .scaleEffect(scale)
            Image(systemName: "heart")
                .resizable()
        }
        .onChange(of: $isLiked.wrappedValue) { newValue in
            withAnimation {
                opacity = isLiked ? 1 : 0
                scale = isLiked ? 1.0 : 0.1
                color = isLiked ? .red : .white
            }
        }
        .task {
            opacity = isLiked ? 1 : 0
            scale = isLiked ? 1.0 : 0.1
            color = isLiked ? .red : .white
        }
        .aspectRatio(contentMode: .fit)
        .onTapGesture {
            onPressed()
        }
        .foregroundColor(color)
    }
}

struct LikeButton_Previews: PreviewProvider {
    static var previews: some View {
        LikeButton(isLiked: .constant(true)){}
    }
}
