// Created 4/6/24
// swift-version:5.0

import SwiftUI

public struct ForEachEnumerated<Content: View, T : Identifiable>: View {
    
    let items: [(Int, T)]
    @ViewBuilder let content: (Int, T) -> Content
    
    /// - Parameters:
    ///   - axis: The axes along which to layout the content.
    ///   - offset: The scroll offset.
    ///   - spacing: The item spacing. (Default = 0)
    ///   - showsIndicators: Whether or not to show the scroll indicators. (Default = true)
    ///   - content: The content to display in the scrollview.
    public init(_ items: [T], @ViewBuilder content: @escaping (Int, T) -> Content) {
        self.items = Array(zip(items.indices, items))
        self.content = content
    }
    
    public var body: some View {
        ForEach(items, id: \.1.id, content: content)
    }
}

