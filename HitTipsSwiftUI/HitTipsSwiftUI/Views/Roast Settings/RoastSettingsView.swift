//
//  RoastStyleView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/23/25.
//

import SwiftUI

struct RoastSettingsView: View {
    @EnvironmentObject var roastSettings: RoastSettings
    @Binding var drawerExpanded: Bool
    @State private var selectedStyle: SelectedRoastStyle = .roast
    
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
            // Roast style buttons
            roastTypeView
            
            // Roast style description
            //            Text(selected == .roast ? UIStrings.roastMeDescription : UIStrings.hypeMeDescription)
            //                .multilineTextAlignment(.center)
            //                .font(.HTBody16)
            //                .padding()
            
            Spacer()
                .frame(height: 40)
            
            // Persona scroll picker
            PersonaPickerView()
            
            Spacer()
            
            Button(drawerExpanded ? "Collapse" : "Expand") {
                drawerExpanded.toggle()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
//            Spacer()
        }
        .padding(.bottom)
    }
    
    private var roastTypeView: some View {
        HStack(spacing: 18) {
            Button {
                print("HTApp: tapped Roast Me")
                selectedStyle = .roast
                roastSettings.roastStyle = SelectedRoastStyle.roast
            } label: {
                Text(UIStrings.roastMe)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(selectedStyle == .roast ? .htOrange : .htPersonaBackground)
            .foregroundColor(.white)
            .appCornerRadius()
            
            Button {
                print("HTApp: tapped Hype Me")
                selectedStyle = .uplifting
                roastSettings.roastStyle = SelectedRoastStyle.uplifting
            } label: {
                Text(UIStrings.hypeMe)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(selectedStyle == .uplifting ? .htOrange : .htPersonaBackground)
            .foregroundColor(.white)
            .appCornerRadius()
        }
    }
}

#Preview {
//    RoastSettingsView(drawerExpanded: Bindable(true))
}
