//
//  HomeView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Go to history") {
                HistoryView()
            }
        }
    }
}

#Preview {
    HomeView()
}
