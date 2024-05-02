// Created 2/1/24
// swift-version:5.0

import SwiftUI

public struct AdaptiveCollectionItem <Thumbnail: View, Detail: View> : View {
    @Environment(\.collectionStyle) var collectionStyle
    
    let spacing: CGFloat?
    let thumbnail: Thumbnail
    let detail: Detail
    
    public init(spacing: CGFloat? = nil, @ViewBuilder thumbnail: () -> Thumbnail, @ViewBuilder detail: () -> Detail) {
        self.spacing = spacing
        self.thumbnail = thumbnail()
        self.detail = detail()
    }
    
    public var body: some View {
        if collectionStyle == .list {
            listView()
        } else {
            gridView()
        }
    }
    
    @ViewBuilder func content() -> some View {
        thumbnail
        detail
    }
    
    @ViewBuilder func listView() -> some View {
        ViewThatFits {
            HStack(alignment: .center, spacing: spacing) {
                content()
                Spacer(minLength: .zero)
            }
            HStack {
                VStack(alignment: .leading, spacing: spacing) {
                    content()
                }
                Spacer(minLength: .zero)
            }
        }
    }
    
    @ViewBuilder func gridView() -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            content()
        }
    }
}

public enum CollectionStyle : Int, Hashable {
    case list, grid, horizontal
}

public struct CollectionStyleEnvironmentKey: EnvironmentKey {
    public static let defaultValue: CollectionStyle = .list
}

extension EnvironmentValues {
    public var collectionStyle: CollectionStyle {
        get { self[CollectionStyleEnvironmentKey.self] }
        set { self[CollectionStyleEnvironmentKey.self] = newValue }
    }
}

extension View {
    public func collectionStyle(_ collectionStyle: CollectionStyle) -> some View {
        environment(\.collectionStyle, collectionStyle)
    }
}

extension View {
    public func collectionThumbnail(width: CGFloat, ratio: CGFloat = 1.0) -> some View {
        modifier(ThumbnailFrameModifier(width: width, ratio: ratio))
    }
}

struct ThumbnailFrameModifier : ViewModifier {
    @Environment(\.collectionStyle) var style
    
    let width: CGFloat
    let ratio: CGFloat
    
    func body(content: Content) -> some View {
        if style == .list {
            content
                .frame(width: width, height: width / ratio)
        } else {
            content
                .aspectRatio(ratio, contentMode: .fit)
        }
    }
}

#Preview {
    AdaptiveCollectionItem {
        Image(systemName: "doc")
            .resizable()
            .collectionThumbnail(width: 64)
    } detail: {
        Text("Lorem ipsum dolor sit amet")
    }
    .padding()
}
