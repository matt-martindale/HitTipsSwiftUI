//
//  ToastView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/28/25.
//

import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.top, 50)
            Spacer()
        }
    }
}

#Preview {
    ToastView(message: "Premium unlocked!")
}
