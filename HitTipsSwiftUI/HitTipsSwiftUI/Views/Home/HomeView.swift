//
//  HomeView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI

struct HomeView: View {
    let viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                TipCalculationView()
            }
            .navigationTitle(Text(viewModel.navigationTitle))
        }
    }
}

#Preview {
    HomeView()
}
