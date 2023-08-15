//
//  CustomSlider.swift
//  CameraTok
//
//  Created by Andres Rojas on 15/08/23.
//

import SwiftUI

struct CustomSlider: View {
    @Binding var percentage: Double
    var onChange: () -> Void

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                Rectangle()
                    .foregroundColor(.accentColor)
                    .frame(width: max(geometry.size.width * CGFloat(self.percentage), 0))
            }
            .cornerRadius(geometry.size.height / 2)
            .highPriorityGesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    self.percentage = min(max(0, value.location.x / geometry.size.width), 1)
                    onChange()
                }))
        }
        .frame(height: 5)
    }
}

struct CustomSlider_Previews: PreviewProvider {
    static var previews: some View {
        CustomSlider(percentage: .constant(0.5)) { }
    }
}
