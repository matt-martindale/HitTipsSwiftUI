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
            // Your main content
            content()
            
            // Overlay loader if isLoading is true
            if isLoading {
                ProgressView(message)
                    .padding(20)
                    .background(.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}
