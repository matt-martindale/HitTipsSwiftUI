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
                    
                    if false {
                        // --- Drawer overlay ---
                        DrawerView(minHeight: 60, maxHeight: 800, isExpanded: $drawerExpanded) {
                            VStack() {
                                Text(UIStrings.roastSettings)
                                    .font(.HTBody18)
                                    .fontWeight(.medium)
                                    .padding(.bottom, 20)
                                
                                HStack(spacing: 12) {
                                    Button {
                                        print("HTApp: tapped Roast Me")
                                    } label: {
                                        Text("🔥 Roast Me")
                                            .fontWeight(.medium)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(.htBrown)
                                    .foregroundColor(.white)
                                    .appCornerRadius()
                                    
                                    Button {
                                        print("HTApp: tapped Hype Me")
                                    } label: {
                                        Text("🌟 Hype Me")
                                            .fontWeight(.medium)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(.htOrange)
                                    .foregroundColor(.white)
                                    .appCornerRadius()
                                }
                                
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
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: Tip.self, inMemory: true)
}
