//
//  RoastStyleView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/23/25.
//

import SwiftUI

enum SelectedRoastStyle {
    case roast, hype, none
}

struct RoastStyleView: View {
    @Binding var drawerExpanded: Bool
    @State private var selected: SelectedRoastStyle = .roast
    
    var body: some View {
        VStack() {
            if !drawerExpanded {
                Text(UIStrings.roastSettings)
                    .font(.HTBody18)
                    .fontWeight(.medium)
                    .padding(.bottom, 20)
            } else {
                Spacer()
                    .frame(height: 30)
            }
            
            HStack(spacing: 18) {
                Button {
                    print("HTApp: tapped Roast Me")
                    selected = .roast
                } label: {
                    Text("🔥 Roast Me")
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(selected == .roast ? .htOrange : .htBrown)
                .foregroundColor(.white)
                .appCornerRadius()
                
                Button {
                    print("HTApp: tapped Hype Me")
                    selected = .hype
                } label: {
                    Text("🌟 Hype Me")
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(selected == .hype ? .htOrange : .htBrown)
                .foregroundColor(.white)
                .appCornerRadius()
            }
            
            Spacer()
            
            Button(drawerExpanded ? "Collapse" : "Expand") {
                drawerExpanded.toggle()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Spacer()
        }
        .padding(.bottom)
    }
}

#Preview {
//    RoastStyleView(drawerExpanded: Bindable(true))
}
