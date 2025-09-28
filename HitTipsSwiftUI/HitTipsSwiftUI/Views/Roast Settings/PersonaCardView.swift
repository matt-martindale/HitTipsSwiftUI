//
//  PersonaCardView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/25/25.
//

import SwiftUI

struct PersonaCardView: View {
    @Environment(\.colorScheme) var colorScheme
    
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
                    .opacity(isSelected ? 1.0 : 0.7)
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
                        .foregroundStyle(textColor())
                        .font(.HTBody14)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity)

                    Text(persona.description)
                        .foregroundStyle(textColor())
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
    
    private func textColor() -> Color {
        if isSelected {
            colorScheme == .dark ? .primary : .white
        } else {
            colorScheme == .dark ? .primary.opacity(0.7) : .black.opacity(0.7)
        }
    }
    
    private func fillColor() -> AnyShapeStyle {
        if persona.isPremium {
            return isSelected ? AnyShapeStyle(LinearGradient(colors: [.purple.opacity(0.8), .blue.opacity(0.8)],startPoint: .topLeading,endPoint: .bottomTrailing)) : AnyShapeStyle(LinearGradient(colors: [.purple.opacity(0.2), .blue.opacity(0.2)],startPoint: .topLeading,endPoint: .bottomTrailing))
        } else {
            return AnyShapeStyle(
                isSelected ? Color.htOrange2 : Color.htPersonaBackground
            )
        }
    }
    
    private func backgroundColor() -> AnyShapeStyle {
        if persona.isPremium {
            return isSelected ? AnyShapeStyle(LinearGradient(colors: [.purple.opacity(0.3), .purple.opacity(0.3)],startPoint: .topLeading,endPoint: .bottomTrailing)) : AnyShapeStyle(LinearGradient(colors: [.purple.opacity(0.2), .blue.opacity(0.2)],startPoint: .topLeading,endPoint: .bottomTrailing))
        } else {
            return AnyShapeStyle(
                isSelected ? Color.htOrange : Color.htPersonaBackground
            )
        }
    }
}

#Preview {
    VStack {
        HStack {
            PersonaCardView(isSelected: false, persona: Persona.all[1])
            PersonaCardView(isSelected: true, persona: Persona.all[1])
        }
        HStack {
            PersonaCardView(isSelected: false, persona: Persona.all[5])
            PersonaCardView(isSelected: true, persona: Persona.all[5])
        }
    }
}
