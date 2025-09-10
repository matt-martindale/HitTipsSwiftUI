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
                HStack(spacing: 8) {
                    Text(viewModel.navigationTitle)
                        .font(.largeTitle) // system inline nav title font
                        .bold()
                    
                    Button {
                        print("Tapped me")
                    } label: {
                        Text("😈")
                            .font(.largeTitle)
                            .padding(2)
                            .contentShape(Rectangle())
                    }
                    Spacer()
                }
                HStack {
                    TipCalculationView()
                }
            }
            .padding()
        }
    }
}


#Preview {
    HomeView()
}
