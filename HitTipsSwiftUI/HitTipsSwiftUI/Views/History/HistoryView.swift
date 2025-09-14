//
//  ContentView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tip: [Tip]

    var body: some View {
        NavigationStack {
            Group {
                if tip.isEmpty {
                    VStack {
                        Image(systemName: "newspaper")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100)
                            .foregroundStyle(.htGray3)
                        Text("No saved tips")
                            .font(.HTBody24)
                            .foregroundStyle(.htGray3)
                    }
                    .padding(30)
                    .background(.htGray)
                    .appCornerRadius()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // 👈 centers the card
                } else {
                    List {
                        ForEach(tip) { tip in
                            NavigationLink {
                                TipDetailView(tip: tip)
                            } label: {
                                Text("\(tip.billAmount)")
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Tip(roast: "test roast", billAmount: "1", totalBill: 2, date: Date(), party: 1, pricePerPerson: 3, tipPerPerson: 4, tipAmount: 5, tipPercentage: 20)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(tip[index])
            }
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: Tip.self, inMemory: true)
}
