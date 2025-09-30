//
//  RoastStyleView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/23/25.
//

import SwiftUI

struct RoastSettingsView: View {
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @EnvironmentObject var roastSettings: RoastSettings
    @Binding var drawerExpanded: Bool
    @State private var selectedStyle: SelectedRoastStyle = .roast
    
    var body: some View {
        VStack {
            if !drawerExpanded {
                Text(UIStrings.roastSettings)
                    .font(.HTBody18)
                    .fontWeight(.medium)
                    .padding(.bottom, 20)
            } else {
                Spacer()
                    .frame(height: 30)
            }
            ScrollView {
                VStack {
                    // Roast style buttons
                    roastTypeView
                    
                    // Roast style description
                    Text(roastSettings.roastStyle == .roast ? UIStrings.roastMeDescription : UIStrings.hypeMeDescription)
                        .multilineTextAlignment(.center)
                        .font(.HTBody14)
                        .padding(12)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    // Persona scroll picker
                    PersonaPickerView()
                    
                    Spacer()
                    
                    //                Button(drawerExpanded ? "Close" : "Expand") {
                    //                    drawerExpanded.toggle()
                    //                }
                    //                .padding()
                    //                .background(.htOrange)
                    //                .foregroundColor(.white)
                    //                .appCornerRadius()
                    
                }
                .padding(.bottom)
                .onChange(of: drawerExpanded) { expanded in
                    if expanded {
                        subscriptionManager.refreshCustomerInfo()
                    }
                }
            }
        }
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
                selectedStyle = .hype
                roastSettings.roastStyle = SelectedRoastStyle.hype
            } label: {
                Text(UIStrings.hypeMe)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(selectedStyle == .hype ? .htOrange : .htPersonaBackground)
            .foregroundColor(.white)
            .appCornerRadius()
        }
    }
}

#Preview {
//    RoastSettingsView(drawerExpanded: Bindable(true))
}
