//
//  PersonaMoreComingView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 10/1/25.
//

import SwiftUI

struct PersonaMoreComingView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        // Card background
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 16)
                .fill(.htPersonaBackground)
                .frame(width: 100, height: 180)
            
            // Text content
            VStack(spacing: 4) {
                Spacer()
                Text(UIStrings.moreComingSoon)
                    .foregroundStyle(.primary)
                    .font(.HTBody18)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(6)
        }
        .frame(width: 100, height: 180, alignment: .top)
    }
}

#Preview {
    PersonaMoreComingView()
}
