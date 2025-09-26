//
//  PersonaCardView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/25/25.
//

import SwiftUI

struct PersonaCardView: View {
    let isSelected: Bool
    let persona: Persona
    
    var body: some View {
        VStack(spacing: 6) {
            // Always top-aligned image
            Image(persona.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 80)
                .padding(.bottom, 4)
//                .padding(.top, 12)

            VStack(spacing: 4) {
                Text(persona.name)
                    .font(.HTBody14)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity)

                Text("Speaks in old English")
                    .font(.HTBody12)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
            }
            .padding(4)
            .frame(minHeight: 60) // 🔑 gives all cards equal text block height
            
            Spacer() // keeps content pushed up
        }
        .frame(width: 100, height: 180, alignment: .top)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? .htOrange : Color.gray.opacity(0.25))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? .htRed : Color.clear, lineWidth: 2)
        )
    }
}

#Preview {
    PersonaCardView(isSelected: false, persona: Persona.all[3])
}
