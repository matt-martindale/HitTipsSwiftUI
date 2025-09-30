//
//  HomeView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject var roastSettings: RoastSettings
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @State private var drawerExpanded = false
    let viewModel = HomeViewModel()
    
    var body: some View {
        SafeAreaReader { _ in
            NavigationStack {
                ZStack {
                    // --- Main Home content ---
                    VStack {
                        HStack(spacing: 8) {
                            Text(viewModel.navigationTitle)
                                .font(.largeTitle)
                                .bold()
                            
                            Button {
                                print("HTApp: Tapped me")
                            } label: {
                                Text(subscriptionManager.isPremiumUser ? "👑" : "😈")
                                    .font(.largeTitle)
                                    .padding(2)
                                    .contentShape(Rectangle())
                            }
                            
                            Spacer()
                        }
                        
                        HStack {
                            TipCalculationView(roastSettings: roastSettings, subscriptionManager: subscriptionManager)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .tint(.primary)
                    
                    // --- Drawer overlay ---
                    let maxHeight = UIScreen.main.bounds.height * 0.9
                    let peekHeight = CGFloat(UIDevice.current.userInterfaceIdiom == .pad ? 350 : 65)
                    DrawerView(
                        maxHeight: maxHeight,
                        peekHeight: peekHeight,
                            isExpanded: $drawerExpanded
                        ) {
                            RoastSettingsView(drawerExpanded: $drawerExpanded)
                        }
                }
                .onAppear {
                    drawerExpanded = false
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
