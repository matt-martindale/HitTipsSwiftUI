//
//  RoastSettingsDrawer.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/22/25.
//

import SwiftUI

struct DrawerView<Content: View>: View {
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @Binding var isExpanded: Bool
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @Environment(\.safeAreaInsets) private var safeInsets
    
    init(minHeight: CGFloat,
         maxHeight: CGFloat,
         isExpanded: Binding<Bool>,
         @ViewBuilder content: () -> Content) {
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self._isExpanded = isExpanded
        self.content = content()
    }
    
    private var collapsedOffset: CGFloat {
        // how much of the drawer is hidden when collapsed
        maxHeight - (minHeight + safeInsets.bottom)
    }
    
    /// 0 = collapsed, 1 = expanded
    private var progress: CGFloat {
        guard collapsedOffset > 0 else { return 1 }
        return 1 - (offset / collapsedOffset)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                // Dimmer behind the drawer
                if progress > 0 {
                    Color.black
                        .opacity(Double(progress) * 0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                offset = collapsedOffset
                                lastOffset = collapsedOffset
                                isExpanded = false
                            }
                        }
                }
                
                // Drawer (always fully drawn; revealed by offset)
                VStack(spacing: 0) {
                    Capsule()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 40, height: 6)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    
                    content
                        .frame(maxHeight: .infinity, alignment: .top)
                }
                .frame(width: geo.size.width, height: maxHeight, alignment: .top)
                .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.htGray)))
                .offset(y: offset)
                .onAppear {
                    // start collapsed
                    offset = collapsedOffset
                    lastOffset = collapsedOffset
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // follow finger relative to where the drawer started for THIS drag
                            let newOffset = lastOffset + value.translation.height
                            offset = min(max(newOffset, 0), collapsedOffset)
                        }
                        .onEnded { value in
                            let mid = collapsedOffset / 2
                            
                            // Use projected vs current translation as a velocity proxy
                            // Negative = flicking up fast; Positive = flicking down fast
                            let projected = value.predictedEndTranslation.height
                            let current   = value.translation.height
                            let impulse   = projected - current
                            
                            // Tune this threshold to taste (pts of extra travel predicted)
                            let flickThreshold: CGFloat = 220
                            
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                if impulse < -flickThreshold {
                                    // fast upward flick → expand
                                    offset = 0
                                    isExpanded = true
                                } else if impulse > flickThreshold {
                                    // fast downward flick → collapse
                                    offset = collapsedOffset
                                    isExpanded = false
                                } else {
                                    // slow drag → snap by position
                                    if offset < mid {
                                        offset = 0
                                        isExpanded = true
                                    } else {
                                        offset = collapsedOffset
                                        isExpanded = false
                                    }
                                }
                            }
                            // new baseline for the next drag
                            lastOffset = offset
                        }
                )
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
