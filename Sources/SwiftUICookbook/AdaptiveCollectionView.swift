// Created 2/1/24
// swift-version:5.0

import SwiftUI

public struct LazyAdaptiveCollectionView<Content: View>: View {
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    let gridWidth: CGFloat
    let spacing: CGFloat?
    let showsIndicators: Bool
    @ViewBuilder let content: () -> Content
    
    /// - Parameters:
    ///   - axis: The axes along which to layout the content.
    ///   - offset: The scroll offset.
    ///   - spacing: The item spacing. (Default = 0)
    ///   - showsIndicators: Whether or not to show the scroll indicators. (Default = true)
    ///   - content: The content to display in the scrollview.
    public init(gridWidth: CGFloat, spacing: CGFloat? = nil, showsIndicators: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.gridWidth = gridWidth
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content
    }
    
    var axis: Axis {
        verticalSizeClass == .compact ? .horizontal : .vertical
    }
    
    var collectionStyle : CollectionStyle {
        axis.isHorizontal ? .horizontal : horizontalSizeClass == .regular ? .grid : .list
    }
    
    public var body: some View {
        ScrollView(axis.set, showsIndicators: showsIndicators) {
            switch collectionStyle {
            case .list:
                LazyVStack(
                    alignment: layoutDirection.isLayoutRTL ? .trailing : .leading,
                    spacing: spacing,
                    content: content)
            case .grid:
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: gridWidth))],
                    spacing: spacing,
                    content: content)
            case .horizontal:
                LazyHStack(spacing: spacing) {
                    content()
                        .frame(idealWidth: gridWidth)
                }
            }
        }
        .defaultScrollAnchor(axis.isHorizontal ? ( layoutDirection.isLayoutRTL ? .trailing : .leading) : .top)
        .collectionStyle(collectionStyle)
    }
}

#Preview {
    LazyAdaptiveCollectionView(gridWidth: 120) {
        ForEach(previewLoremIpsum) { item in
            Text(item.text)
                .border(.green)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
    .padding()
}

struct LoremIpsum : Identifiable, Hashable {
    var id: String { text }
    let text: String
}

let previewLoremIpsum: [LoremIpsum] = loremIpsum.components(separatedBy: .punctuationCharacters).compactMap {
    let text = $0.trimmingCharacters(in: .whitespacesAndNewlines)
    return text.isEmpty ? nil : LoremIpsum(text: text)
}
fileprivate let loremIpsum = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Libero enim sed faucibus turpis in eu mi bibendum neque. Nisl suscipit adipiscing bibendum est ultricies integer. Purus in massa tempor nec feugiat nisl. Dictum fusce ut placerat orci nulla pellentesque. Justo laoreet sit amet cursus sit amet. Nibh mauris cursus mattis molestie a iaculis. Id aliquet lectus proin nibh nisl condimentum id venenatis. Lorem mollis aliquam ut porttitor leo a diam sollicitudin tempor. Eget est lorem ipsum dolor sit amet consectetur. Mauris cursus mattis molestie a iaculis at erat pellentesque. Integer enim neque volutpat ac tincidunt vitae semper. Sit amet massa vitae tortor. Cursus sit amet dictum sit amet justo. Tempor commodo ullamcorper a lacus vestibulum sed arcu non odio. Sit amet consectetur adipiscing elit ut aliquam purus sit amet. Dictum at tempor commodo ullamcorper a. Elit scelerisque mauris pellentesque pulvinar pellentesque habitant. Massa sapien faucibus et molestie ac feugiat sed lectus. Lobortis feugiat vivamus at augue eget arcu dictum varius. Vitae nunc sed velit dignissim sodales ut eu sem integer. Arcu felis bibendum ut tristique et egestas. Purus semper eget duis at tellus at urna condimentum. Lacus vel facilisis volutpat est velit egestas dui. Consectetur adipiscing elit pellentesque habitant morbi. Est pellentesque elit ullamcorper dignissim cras tincidunt. Est ullamcorper eget nulla facilisi etiam dignissim diam quis enim. Scelerisque eleifend donec pretium vulputate. Fermentum odio eu feugiat pretium nibh ipsum. Mattis nunc sed blandit libero volutpat sed. Augue lacus viverra vitae congue. Ullamcorper sit amet risus nullam eget felis eget. Quisque id diam vel quam elementum. Sed libero enim sed faucibus turpis in. At tellus at urna condimentum mattis pellentesque id. Faucibus interdum posuere lorem ipsum. Aliquet nibh praesent tristique magna sit amet. Aliquam sem fringilla ut morbi tincidunt. Risus in hendrerit gravida rutrum quisque non tellus orci. Purus faucibus ornare suspendisse sed nisi lacus sed viverra. Augue eget arcu dictum varius duis at consectetur. Et egestas quis ipsum suspendisse ultrices gravida. Egestas purus viverra accumsan in nisl nisi scelerisque eu ultrices. Amet volutpat consequat mauris nunc. Vitae purus faucibus ornare suspendisse. Tortor aliquam nulla facilisi cras fermentum odio eu. Purus non enim praesent elementum facilisis leo vel fringilla. Egestas egestas fringilla phasellus faucibus scelerisque eleifend donec pretium vulputate. Tellus rutrum tellus pellentesque eu tincidunt. Convallis aenean et tortor at risus. At imperdiet dui accumsan sit amet. Sed lectus vestibulum mattis ullamcorper velit. Purus gravida quis blandit turpis. Sed egestas egestas fringilla phasellus faucibus scelerisque eleifend. Sollicitudin aliquam ultrices sagittis orci a. Et tortor at risus viverra. Vivamus arcu felis bibendum ut tristique et egestas. Eget mi proin sed libero enim sed faucibus turpis. Eu sem integer vitae justo eget magna fermentum iaculis eu. Vestibulum rhoncus est pellentesque elit ullamcorper dignissim. Porttitor massa id neque aliquam. Aliquam malesuada bibendum arcu vitae elementum curabitur vitae. Justo nec ultrices dui sapien eget mi proin. Eget mauris pharetra et ultrices neque ornare aenean euismod. Id velit ut tortor pretium viverra suspendisse potenti. Orci porta non pulvinar neque laoreet suspendisse interdum consectetur. Maecenas accumsan lacus vel facilisis. Lacus suspendisse faucibus interdum posuere lorem ipsum dolor sit. Fringilla phasellus faucibus scelerisque eleifend. Bibendum arcu vitae elementum curabitur vitae. Maecenas volutpat blandit aliquam etiam erat. Lacus luctus accumsan tortor posuere ac. Vitae suscipit tellus mauris a diam maecenas sed enim. Vel risus commodo viverra maecenas accumsan lacus vel. Augue neque gravida in fermentum et sollicitudin. Suscipit tellus mauris a diam maecenas sed. Maecenas volutpat blandit aliquam etiam erat velit scelerisque in dictum. Justo laoreet sit amet cursus sit amet dictum sit. Volutpat commodo sed egestas egestas fringilla phasellus faucibus scelerisque eleifend. Magna eget est lorem ipsum. Lacus laoreet non curabitur gravida arcu ac tortor dignissim. Suspendisse interdum consectetur libero id faucibus nisl tincidunt. Sit amet mauris commodo quis imperdiet massa. Mauris sit amet massa vitae tortor condimentum lacinia. Ultricies leo integer malesuada nunc vel. Elit ut aliquam purus sit amet luctus. Aliquet nibh praesent tristique magna sit amet purus gravida. Arcu cursus vitae congue mauris rhoncus aenean. Morbi tempus iaculis urna id volutpat lacus. Fringilla phasellus faucibus scelerisque eleifend donec pretium vulputate sapien nec. Eget velit aliquet sagittis id consectetur purus. Venenatis lectus magna fringilla urna porttitor rhoncus dolor purus. At in tellus integer feugiat. Integer quis auctor elit sed vulputate mi sit. Tellus in metus vulputate eu scelerisque felis imperdiet proin fermentum. Tristique et egestas quis ipsum suspendisse ultrices gravida dictum. Aliquet nec ullamcorper sit amet risus nullam eget. Faucibus scelerisque eleifend donec pretium vulputate sapien nec sagittis. Aliquet sagittis id consectetur purus. Amet risus nullam eget felis eget nunc lobortis mattis.
"""
    
