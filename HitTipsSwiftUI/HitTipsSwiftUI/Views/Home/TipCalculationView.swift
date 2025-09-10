//
//  TipCalculationView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData
import FirebaseFunctions

struct TipCalculationView: View {
    
    @Environment(\.modelContext) private var context
    @Query(filter: nil, sort: \Tip.date, order: .reverse) private var tips: [Tip]
    @StateObject var apiService = APIService()

    @State private var billAmount = "0.00"
    @State private var tipAmount = 15
    @State private var party = 1
    @State private var tipPercent = 15

    var body: some View {
        NavigationStack {
            VStack {
                
                HTTextField(title: "BILL AMOUNT", value: $billAmount, keyboardType: .decimalPad)
                HStack {
                    HTPickerView(upperLimit: 20, icon: "person.2.fill", iconLeading: true)
                    VStack {
                        HTTextField(title: "TIP AMOUNT", value: $tipAmount, isDisabled: true)
                            .padding()
                        HTTextField(title: "TIP/PERSON", value: $tipAmount, isDisabled: true)
                    }
                    HTPickerView(upperLimit: 40, icon: "percent", iconLeading: false, initialValue: 15)
                }
                Spacer()
                
//                Form {
//                    Section("Add Tip") {
//                        TextField("Bill Amount", text: $billAmount)
//                            .keyboardType(.decimalPad)
//
//                        Stepper("Party: \(party)", value: $party, in: 1...20)
//                        Stepper("Tip %: \(tipPercent)", value: $tipPercent, in: 0...100)
//
//                        Button("Add Tip") {
//                            apiService.callFirebaseApi { response in
//                                if let response = response {
//                                    responseMessage = response
//                                }
//                            }
//                            addTip()
//                        }
//                        .buttonStyle(.borderedProminent)
//                    }
//
//                    Section("Tips") {
//                        List(tips, id: \.id) { tip in
//                            VStack(alignment: .leading) {
//                                Text("Bill: \(tip.billAmount)")
//                                Text("Tip: \(String(format: "%.2f", tip.tipAmount))")
//                                Text("Total: \(String(format: "%.2f", tip.totalBill))")
//                                Text("Price/Person: \(String(format: "%.2f", tip.pricePerPerson))")
//                                Text("Tip/Person: \(String(format: "%.2f", tip.tipPerPerson))")
//                            }
//                            .padding(4)
//                        }
//                    }
//                }
            }
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

#Preview {
    TipCalculationView()
}
