//
//  ContentView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData
import GoogleMobileAds

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Tip.date, order: .reverse) private var tip: [Tip]
    @State private var showingDeleteAllConfirm = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    if tip.isEmpty {
                        // Empty state card
                        VStack {
                            Image(systemName: "newspaper")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .foregroundStyle(.gray)
                            Text(UIStrings.noSavedTips)
                                .font(.title2)
                                .foregroundStyle(.gray)
                        }
                        .padding(30)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        // List of tips
                        List {
                            Section(header: HistoryViewHeaderView()
                                .foregroundStyle(.gray)
                                .padding(.vertical, 4)
                            ) {
                                ForEach(tip) { tip in
                                    NavigationLink {
                                        TipDetailView(tip: tip)
                                    } label: {
                                        HistoryListItemView(tip: tip)
                                    }
                                }
                                .onDelete(perform: deleteItems)
                            }
                        }
                    }
                }
                .navigationTitle(UIStrings.history)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(role: .destructive) {
                            showingDeleteAllConfirm = true
                        }
                        label: {
                            Image(systemName: "trash")
                                .tint(.primary)
                        }
                        .disabled(tip.isEmpty)
                    }
                }
                // Delete All confirmation
                .confirmationDialog(
                    UIStrings.deleteAllTips,
                    isPresented: $showingDeleteAllConfirm,
                    titleVisibility: .visible
                ) {
                    Button("Delete All", role: .destructive) {
                        deleteAllItems()
                    }
                    Button("Cancel", role: .cancel) {}
                }
                VStack {
                    Spacer()
                    // Banner ad
                    BannerAdView(adUnitID: HTAdManager.historyAdBanner)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }
            }
        }
        .tint(.primary)
    }
    
    // MARK: - Actions
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets { modelContext.delete(tip[index]) }
        }
    }
    
    private func deleteAllItems() {
        withAnimation {
            for item in tip { modelContext.delete(item) }
        }
    }
}

// MARK: - Preview
#Preview {
    HistoryView()
        .modelContainer(for: Tip.self, inMemory: true)
}
