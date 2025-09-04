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
        List {
            ForEach(tip) { tip in
                NavigationLink {
                    Text("Item at \(tip.date)")
                } label: {
                    Text("\(tip.billAmount)")
                }
            }
            .onDelete(perform: deleteItems)
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

    private func addItem() {
        withAnimation {
            let newItem = Tip(billAmount: 1, totalBill: 2, date: Date(), party: 1, pricePerPerson: 3, tipPerPerson: 4, tipAmount: 5, tipPercentage: 20)
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
