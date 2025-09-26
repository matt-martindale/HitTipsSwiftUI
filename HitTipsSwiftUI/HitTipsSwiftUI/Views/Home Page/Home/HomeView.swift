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
                                Text("😈")
                                    .font(.largeTitle)
                                    .padding(2)
                                    .contentShape(Rectangle())
                            }
                            
                            Spacer()
                        }
                        
                        HStack {
                            TipCalculationView(roastSettings: roastSettings)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .tint(.primary)
                    
                    // --- Drawer overlay ---
                    DrawerView(minHeight: 60, maxHeight: 800, isExpanded: $drawerExpanded) {
                        RoastSettingsView(drawerExpanded: $drawerExpanded)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
