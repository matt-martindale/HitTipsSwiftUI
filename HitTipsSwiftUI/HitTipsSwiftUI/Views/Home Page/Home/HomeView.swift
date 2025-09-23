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
                    DrawerView(minHeight: 60, maxHeight: 800, isExpanded: $drawerExpanded) {
                        VStack() {
                            Text("Roast settings")
                                .font(.HTBody18)
                                .foregroundStyle(.secondary)
                                .padding(.bottom)
                            
                            Text("Swipe up to expand, down to collapse.")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                            
                            Button(drawerExpanded ? "Collapse" : "Expand") {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                                    drawerExpanded.toggle()
                                }
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
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Tip.self, inMemory: true)
}
