//
//  HomeView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject var fireStoreManager: FirestoreManager
    @Environment(\.modelContext) private var context
    @Query(sort: \Tip.date, order: .reverse) private var tips: [Tip]
    
    let viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 8) {
                    Text(viewModel.navigationTitle)
                        .font(.largeTitle) // system inline nav title font
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
                        .environmentObject(fireStoreManager)
                }
            }
            .padding()
        }
        .tint(.primary)
    }
}


#Preview {
    HomeView()
}
