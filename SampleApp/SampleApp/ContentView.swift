// Created 4/25/24
// swift-version:5.0

import SwiftUI
@testable import SwiftUICookbook

struct ContentView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var axis: Axis {
        return verticalSizeClass == .compact ? .horizontal : .vertical
    }
    
    var body: some View {
        PreviewLazyObservingScrollView(axis: axis)
            .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    ContentView()
}
