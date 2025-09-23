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
    
    let viewModel = HomeViewModel()
    @State private var drawerExpanded = false
    
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
                            TipCalculationView(context: context)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .tint(.primary)
                    
                    // --- Drawer overlay ---
                    DrawerView(minHeight: 70, maxHeight: 800, isExpanded: $drawerExpanded) {
                        VStack() {
                            Text("Roast settings")
                                .font(.HTBody20)
                            
                            Text("Swipe up to expand, down to collapse.")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                            
                            Button(drawerExpanded ? "Collapse" : "Expand") {
                                drawerExpanded.toggle()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Spacer()
                        }
                        .padding()
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
