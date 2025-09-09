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
    @State private var currentTab: TabIdentifier = .home
    
    var body: some View {
        TabView(selection: $currentTab) {
            Tab("HitTips", systemImage: "house", value: TabIdentifier.home) {
                HomeView()
            }
            Tab("History", systemImage: "gear", value: TabIdentifier.history) {
                HistoryView()
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    ContentView()
}
