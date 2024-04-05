// Created 4/4/24
// swift-version:5.0

import SwiftUI

/// A stack view intended for the display of a list of items. This view is backwards-compatible to older OS and vends a stack 
/// layout using on the requested axis.
public struct ListViewStack<Content> : View where Content : View {
    
    let axis: Axis
    let isLazy: Bool
    let spacing: CGFloat
    let content: Content
    
    /// - Parameters:
    ///   - axis: The axis along which to layout views.
    ///   - isLazy: Whether or not the vended container is lazy load.
    ///   - spacing: The spacing between elements in the container.
    ///   - content: The content view builder.
    public init(_ axis: Axis, isLazy: Bool = false, spacing: CGFloat = 0, @ViewBuilder content: () -> Content) {
        self.axis = axis
        self.isLazy = isLazy
        self.spacing = spacing
        self.content = content()
    }
    
    public var body: some View {
        if axis == .horizontal {
            if isLazy {
                LazyHStack(spacing: spacing) {
                    content
                }
            } else {
                HStack(spacing: spacing) {
                    content
                }
            }
        } else {
            if isLazy {
                LazyVStack(spacing: spacing) {
                    content
                }
            } else {
                VStack(spacing: spacing) {
                    content
                }
            }
        }
    }
}

#Preview {
    ListViewStack(.horizontal) {
        ForEach(0..<10) { ii in
            Text("\(ii)")
        }
    }.padding()
}
