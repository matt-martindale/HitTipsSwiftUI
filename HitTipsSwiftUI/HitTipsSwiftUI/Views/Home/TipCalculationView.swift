//
//  TipCalculationView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData

struct TipCalculationView: View {
    @Environment(\.modelContext) private var context
    @Query(
        filter: nil,
        sort: \Tip.date,
        order: .reverse
    ) private var tips: [Tip]

    @State private var billAmount = ""
    @State private var party = 1
    @State private var tipPercent = 15

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section("Add Tip") {
                        TextField("Bill Amount", text: $billAmount)
                            .keyboardType(.decimalPad)

                        Stepper("Party: \(party)", value: $party, in: 1...20)
                        Stepper("Tip %: \(tipPercent)", value: $tipPercent, in: 0...100)

                        Button("Add Tip") {
                            addTip()
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    Section("Tips") {
                        List(tips, id: \.id) { tip in
                            VStack(alignment: .leading) {
                                Text("Bill: \(tip.billAmount)")
                                Text("Tip: \(String(format: "%.2f", tip.tipAmount))")
                                Text("Total: \(String(format: "%.2f", tip.totalBill))")
                                Text("Price/Person: \(String(format: "%.2f", tip.pricePerPerson))")
                                Text("Tip/Person: \(String(format: "%.2f", tip.tipPerPerson))")
                            }
                            .padding(4)
                        }
                    }
                }
            }
            .navigationTitle("Tip Calculator")
        }
    }

    private func addTip() {
        guard let bill = Double(billAmount) else { return }
        let tipAmount = bill * Double(tipPercent) / 100
        let total = bill + tipAmount
        let pricePerPerson = total / Double(party)
        let tipPerPerson = tipAmount / Double(party)

        let newTip = Tip(
            billAmount: String(format: "%.2f", bill),
            totalBill: total,
            date: Date(),
            party: party,
            pricePerPerson: pricePerPerson,
            tipPerPerson: tipPerPerson,
            tipAmount: tipAmount,
            tipPercentage: tipPercent
        )

        context.insert(newTip)

        // Reset input fields
        billAmount = ""
        party = 1
        tipPercent = 15
    }
}

