// Created 4/6/24
// swift-version:5.0

import SwiftUI

public extension View {
    
    /// Add a border only along the selected edges
    /// - Parameters:
    ///   - width: The width of the border.
    ///   - edges: The edges along which to draw the border.
    ///   - color: The color of the border.
    /// - Returns: An overlay view with the borders drawn to the inside of the selected edges.
    func border(width: CGFloat, edges: Edge.Set, color: Color) -> some View {
        overlay(
            SelectedEdgeBorder(width: width, edges: edges)
                .foregroundColor(color)
        )
    }
}

struct SelectedEdgeBorder: Shape {
    var width: CGFloat
    var edges: Edge.Set

    func path(in rect: CGRect) -> Path {
        Path { path in
            if edges.contains(.top) {
                path.addRect(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            }
            if edges.contains(.bottom) {
                path.addRect(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            }
            if edges.contains(.leading) {
                path.addRect(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            }
            if edges.contains(.trailing) {
                path.addRect(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }
    }
}

#Preview {
    Text("Hello, World!")
        .padding()
        .border(width: 1.5, edges: [.top, .bottom], color: .blue)
        .border(width: 1.5, edges: [.trailing, .leading], color: .green)
        .padding()
}
