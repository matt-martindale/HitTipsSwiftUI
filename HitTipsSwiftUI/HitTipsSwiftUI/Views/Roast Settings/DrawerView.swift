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
        maxHeight - (minHeight + safeInsets.bottom)
    }
    
    private var progress: CGFloat {
        guard collapsedOffset > 0 else { return 1 }
        return 1 - (offset / collapsedOffset)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                if progress > 0 {
                    Color.black
                        .opacity(Double(progress) * 0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                collapse()
                            }
                        }
                }
                
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
                    offset = collapsedOffset
                    lastOffset = collapsedOffset
                }
                .onChange(of: isExpanded) { newValue in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        if newValue {
                            expand()
                        } else {
                            collapse()
                        }
                        lastOffset = offset
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newOffset = lastOffset + value.translation.height
                            offset = min(max(newOffset, 0), collapsedOffset)
                        }
                        .onEnded { value in
                            let mid = collapsedOffset / 2
                            let projected = value.predictedEndTranslation.height
                            let current   = value.translation.height
                            let impulse   = projected - current
                            let flickThreshold: CGFloat = 280
                            
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                if impulse < -flickThreshold {
                                    expand()
                                } else if impulse > flickThreshold {
                                    collapse()
                                } else {
                                    if offset < mid { expand() }
                                    else { collapse() }
                                }
                            }
                            lastOffset = offset
                        }
                )
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    // MARK: - Internal controls
    private func expand() {
        offset = 0
        isExpanded = true
    }
    
    private func collapse() {
        offset = collapsedOffset
        isExpanded = false
    }
}

