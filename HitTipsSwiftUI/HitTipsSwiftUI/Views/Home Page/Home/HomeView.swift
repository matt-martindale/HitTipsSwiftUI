//
//  HomeView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Tip.date, order: .reverse) private var tips: [Tip]
    
    @State private var drawerExpanded = false
    @StateObject private var roastSettings = RoastSettings()
    
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
                            TipCalculationView(context: context, roastSettings: roastSettings)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .tint(.primary)
                    
                    if true { // Toggle for roast drawer
                        // --- Drawer overlay ---
                        DrawerView(minHeight: 60, maxHeight: 800, isExpanded: $drawerExpanded) {
                            RoastStyleView(drawerExpanded: $drawerExpanded)
                                .environmentObject(roastSettings)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Tip.self, inMemory: true)
}
