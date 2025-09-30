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
//        TabView(selection: $currentTab) {
//            Tab(UIStrings.hitTips, systemImage: "exclamationmark.square", value: TabIdentifier.home) {
                HomeView()
//            }
//            Tab(UIStrings.history, systemImage: "newspaper", value: TabIdentifier.history) {
//                HistoryView()
//            }
//        }
//        .tint(.primary)
    }
}

#Preview {
    ContentView()
}
