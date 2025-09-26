//
//  ContentView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Tip.date, ascending: false)],
        animation: .default
    ) private var tips: FetchedResults<Tip>
    
    @State private var showingDeleteAllConfirm = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                content
                    .navigationTitle(UIStrings.history)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            deleteAllButton
                        }
                    }
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
                
                bannerAd
            }
        }
        .tint(.primary)
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var content: some View {
        if tips.isEmpty {
            emptyState
        } else {
            tipsList
        }
    }
    
    private var emptyState: some View {
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
    }
    
    private var tipsList: some View {
        List {
            Section(
                header: HistoryViewHeaderView()
                    .foregroundStyle(.gray)
                    .padding(.vertical, 4)
            ) {
                ForEach(tips) { tip in
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
    
    private var deleteAllButton: some View {
        Button(role: .destructive) {
            showingDeleteAllConfirm = true
        } label: {
            Image(systemName: "trash")
                .tint(.primary)
        }
        .disabled(tips.isEmpty)
    }
    
    private var bannerAd: some View {
        VStack {
            Spacer()
            BannerAdView(adUnitID: HTAdManager.historyAdBanner)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
        }
    }
    
    // MARK: - Actions
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(tips[index])
            }
            saveContext()
        }
    }
    
    private func deleteAllItems() {
        withAnimation {
            let allTips = Array(tips)   // snapshot
            allTips.forEach { context.delete($0) }
            saveContext()
        }
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context after delete: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview
#Preview {
    HistoryView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
