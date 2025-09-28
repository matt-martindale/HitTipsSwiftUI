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
        ZStack(alignment: .top) {
            // Card background
            RoundedRectangle(cornerRadius: 16)
                .fill(fillColor())
                .frame(width: 100, height: 180)
            
            VStack(spacing: 6) {
                Image(persona.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 90)
                    .allowsHitTesting(false)
                    .background(backgroundColor())
                    .clipShape(UnevenRoundedRectangle(
                        topLeadingRadius: 16,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 16
                    ))
                
                // Text content
                VStack(spacing: 4) {
                    Text(persona.name)
                        .foregroundStyle(.white)
                        .font(.HTBody14)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)

                    Text(persona.description)
                        .foregroundStyle(.white)
                        .font(.HTBody10)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)
                }
                .padding(6)
                .frame(height: 70)
                
                Spacer()
            }
            .frame(width: 100, height: 180, alignment: .top)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? .htRed : Color.clear, lineWidth: 2)
                )
                .frame(width: 100, height: 180)
        }
        .frame(width: 100, height: 200)
    }
    
    private func fillColor() -> Color {
        if persona.isPremium {
            return isSelected ? .htBlue : .htPersonaBackground
        } else {
            return isSelected ? .htOrange2 : .htPersonaBackground
        }
    }
    
    private func backgroundColor() -> Color {
        if persona.isPremium {
            return isSelected ? .htPurple : .htPersonaBackground
        } else {
            return isSelected ? .htOrange : .htPersonaBackground
        }
    }
}

#Preview {
    PersonaCardView(isSelected: true, persona: Persona.all[1])
}
