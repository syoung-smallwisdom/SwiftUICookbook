// Created 4/4/24
// swift-version:5.0

import SwiftUI

/// A scrollview calculates the offset position of the scrollview, including support for right-to-left layout.
public struct LazyObservingScrollView<Content: View>: View {
    @Environment(\.layoutDirection) private var layoutDirection
    
    let axis: Axis
    let spacing: CGFloat?
    let showsIndicators: Bool
    let content: Content
    
    @Binding var offset: CGFloat
    @State private var overallLength: CGFloat = .zero
    @State private var spacerLength: CGFloat = .zero
    
    // Use a UUID for the coordinate space so that it is unique.
    private let coordinateSpaceName = UUID()
    
    /// - Parameters:
    ///   - axis: The axes along which to layout the content.
    ///   - offset: The scroll offset.
    ///   - spacing: The item spacing. (Default = 0)
    ///   - showsIndicators: Whether or not to show the scroll indicators. (Default = true)
    ///   - content: The content to display in the scrollview.
    public init(_ axis: Axis, offset: Binding<CGFloat>, spacing: CGFloat? = nil, showsIndicators: Bool = true, @ViewBuilder content: () -> Content) {
        self.axis = axis
        self._offset = offset
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    public var body: some View {
        ScrollView(axis.set, showsIndicators: showsIndicators) {
            ListViewStack(axis) {
                ListViewStack(axis, isLazy: true, spacing: spacing) {
                    content
                }
                .background(GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollOffsetPreferenceKey.self,
                        value: geometry.frame(in: .named(coordinateSpaceName)))
                })
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { frame in
                    let length = (axis == .vertical) ? frame.height : frame.width
                    // a spacer is used at the end to push the content to the top|right|left
                    let newSpacerLength = max(0, overallLength - length)
                    if axis.isHorizontal && layoutDirection.isLayoutRTL {
                        // If this is a horizontal scroller with right-to-left layout
                        // then scrolling is reversed and the "zero" position is the right
                        // side of the frame.
                        if newSpacerLength != self.spacerLength, newSpacerLength > 0 {
                            // If the spacer size has changed, then the geometry changed
                            // because the content size changed and *not* because the user
                            // is force pulling the scroll. Therefore, the offset will snap
                            // to zero.
                            self.offset = 0
                        } else {
                            self.offset = frame.maxX - overallLength
                        }
                    } else {
                        // If this is not right-to-left layout then the offset is
                        // in the minus direction.
                        self.offset = -1 * (axis.isHorizontal ? frame.minX : frame.minY)
                    }
                    self.spacerLength = newSpacerLength
                }
                
                // The spacer is used in a non-lazy stack so that the geometry calculations
                // do not include it.
                Spacer(minLength: spacerLength)
            }
        }
        .defaultScrollAnchor(axis.isHorizontal ? ( layoutDirection.isLayoutRTL ? .trailing : .leading) : .top)
        .coordinateSpace(name: coordinateSpaceName)
        .lengthReader($overallLength, isHeight: axis == .vertical)
    }
    
    struct ScrollOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGRect { .zero }
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
            // do nothing
        }
    }
}

public extension Axis {
    
    /// The corresponding `Axis.Set` for this axis.
    var set: Set {
        self == .horizontal ? .horizontal : .vertical
    }
    
    /// What is the opposite axis?
    var opposite: Axis {
        self == .horizontal ? .vertical : .horizontal
    }
    
    /// Is this a horizontal scrollview?
    var isHorizontal: Bool {
        self == .horizontal
    }
}

public extension LayoutDirection {
    
    /// Is the layout right-to-left?
    var isLayoutRTL: Bool {
        self == .rightToLeft
    }
}

/// The preview is used to allow testing the scrollview with some default values
struct PreviewLazyObservingScrollView : View {
    var axis: Axis = .horizontal
    
    @State var offsetA: CGFloat = .zero
    @State var offsetB: CGFloat = .zero
    @State var listA: [Int] = Array(1...200)
    @State var listB: [Int] = Array(1...7)
    
    var body: some View {
        ListViewStack(axis.opposite) {

                Text("\(offsetA)")
                LazyObservingScrollView(axis, offset: $offsetA) {
                    ForEach(listA, id: \.self) { ii in
                        Button(action: { listA.removeLast() } ) {
                            Text("\(ii)")
                                .padding()
                        }
                    }
                }
                Text("\(offsetB)")
                LazyObservingScrollView(axis, offset: $offsetB) {
                    ForEach(listB, id: \.self) { ii in
                        Button(action: { listB.append(listB.count + 1) } ) {
                            Text("\(ii)")
                                .padding()
                        }
                    }
                }
                
        }
    }
}

#Preview {
    VStack {
        PreviewLazyObservingScrollView()
            .environment(\.layoutDirection, .leftToRight)
            .border(.black)
        
        PreviewLazyObservingScrollView()
            .environment(\.layoutDirection, .rightToLeft)
            .border(.black)
    }
}

#Preview {
    PreviewLazyObservingScrollView(axis: .vertical)
        .border(.black)
}
