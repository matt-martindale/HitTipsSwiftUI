//
//  LoaderView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/12/25.
//

import SwiftUI

struct LoaderView<Content: View>: View {
    @Binding var isLoading: Bool
    @Binding var message: String
    let content: () -> Content

    init(isLoading: Binding<Bool>, message: Binding<String>, @ViewBuilder content: @escaping () -> Content) {
        self._isLoading = isLoading
        self._message = message
        self.content = content
    }

    var body: some View {
        ZStack {
            // Main content
            content()
            
            // Loader overlay
            if isLoading {
                // Blocks interaction with background
                Color.black.opacity(0.001)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(true) // ensures touches don't pass through
                
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(1.5)
                    Text(message)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(20)
                .background(.ultraThinMaterial) // modern blur
                .cornerRadius(12)
                .shadow(radius: 10)
                .allowsHitTesting(false) // loader itself does not intercept taps
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}

