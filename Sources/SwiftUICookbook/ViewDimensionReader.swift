// Created 2/5/24
// swift-version:5.0

import SwiftUI

public extension View {
    
    /// Read the height of a view.
    func heightReader(height: Binding<CGFloat>) -> some View {
        modifier(ViewDimensionReader(height))
    }
    
    /// Read the width of a view.
    func widthReader(width: Binding<CGFloat>) -> some View {
        modifier(ViewDimensionReader(width, isHeight: false))
    }
    
    /// Read the length of a view.
    /// - Parameters:
    ///   - length: The binding for the dimension to be measured.
    ///   - isHeight: Whether or not the dimension is the height (or width).
    /// - Returns: A modified view.
    func lengthReader(_ length: Binding<CGFloat>, isHeight: Bool) -> some View {
        modifier(ViewDimensionReader(length, isHeight: isHeight))
    }
}

struct ViewDimensionReader : ViewModifier {
    @Binding var dim: CGFloat
    let isHeight: Bool
    
    init(_ dim: Binding<CGFloat>, isHeight: Bool = true) {
        self._dim = dim
        self.isHeight = isHeight
    }
    
    func body(content: Content) -> some View {
        content
            .background(GeometryReader {
                Color.clear.preference(key: ViewDimensionKey.self,
                                       value: self.isHeight ? $0.frame(in: .local).size.height : $0.frame(in: .local).size.width
                )
            })
            .onPreferenceChange(ViewDimensionKey.self) {
                if dim != $0 { dim = $0 }   // Only set if it changed
            }
    }
    
    private struct ViewDimensionKey: PreferenceKey {
        static var defaultValue: CGFloat { .zero }
        static func reduce(value: inout Value, nextValue: () -> Value) {
            // do nothing
        }
    }
}

