//
//  RoastSettingsDrawer.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/22/25.
//

import SwiftUI

struct DrawerView<Content: View>: View {
    let maxHeight: CGFloat        // expanded height
    let peekHeight: CGFloat       // how much is visible when collapsed
    let content: Content
    
    @Binding var isExpanded: Bool
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    
    @Environment(\.safeAreaInsets) private var safeInsets
    
    init(
        maxHeight: CGFloat,
        peekHeight: CGFloat = 22, // just the handle visible
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self.maxHeight = maxHeight
        self.peekHeight = peekHeight
        self._isExpanded = isExpanded
        self.content = content()
    }
    
    private var collapsedOffset: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        
        if screenHeight <= 667 {
            return maxHeight - (peekHeight + UITabBar.height - 97)
        }
        
        // Default for all other iPhones
        return maxHeight - (peekHeight + UITabBar.height)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                if isExpanded {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { collapse() }
                }
                
                VStack(spacing: 0) {
                    Capsule()
                        .fill(Color.gray.opacity(0.6))
                        .frame(width: 40, height: 6)
                        .padding(.vertical, 8)
                    
                    content
                        .frame(maxHeight: .infinity, alignment: .top)
                }
                .frame(width: geo.size.width, height: maxHeight, alignment: .top)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(.systemGray6))
                )
                .offset(y: offset)
                .onAppear {
                    offset = collapsedOffset
                    lastOffset = collapsedOffset
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            // Continuous drag follow
                            let newOffset = lastOffset + value.translation.height
                            offset = min(max(newOffset, 0), collapsedOffset)
                        }
                        .onEnded { value in
                            let dragVelocity = value.predictedEndTranslation.height - value.translation.height
                            let mid = collapsedOffset / 2
                            let flickThreshold: CGFloat = 250 // tweak sensitivity
                            
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                if dragVelocity < -flickThreshold {
                                    // strong upward flick → expand
                                    expand()
                                } else if dragVelocity > flickThreshold {
                                    // strong downward flick → collapse
                                    collapse()
                                } else {
                                    // settle to nearest state
                                    if offset < mid { expand() }
                                    else { collapse() }
                                }
                            }
                            lastOffset = offset
                        }
                )
                
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        if isExpanded { collapse() } else { expand() }
                    }
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func expand() {
        offset = 0
        isExpanded = true
    }
    
    private func collapse() {
        offset = collapsedOffset
        isExpanded = false
    }
}
