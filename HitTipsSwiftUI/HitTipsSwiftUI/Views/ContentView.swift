//
//  ContentView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI

enum TabIdentifier: Hashable {
    case home, history
}

struct ContentView: View {
    @EnvironmentObject var fireStoreManager: FirestoreManager
    @State private var currentTab: TabIdentifier = .home
    
    var body: some View {
        TabView(selection: $currentTab) {
            Tab("HitTips", systemImage: "house", value: TabIdentifier.home) {
                HomeView()
                    .environmentObject(fireStoreManager)
            }
            Tab("History", systemImage: "gear", value: TabIdentifier.history) {
                HistoryView()
            }
        }
        .tint(.primary)
    }
}

#Preview {
    ContentView()
}
