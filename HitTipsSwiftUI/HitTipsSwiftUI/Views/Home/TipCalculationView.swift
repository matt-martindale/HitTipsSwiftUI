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
    @FocusState private var isInputFocused: Bool

    @State private var billAmount = "0.00"
    @State private var tipAmount = "0.00"
    @State private var party: Int?
    @State private var tipPercent: Int?
    @State private var tipPerPerson = "0.00"
    @State private var pricePerPerson = "0.00"
    @State private var totalBill = "0.00"

    var body: some View {
        NavigationStack {
            VStack {
                HTTextField(title: UIStrings.billAmount, value: $billAmount, keyboardType: .decimalPad)
                    .padding(.top)
                    .padding(.horizontal)
                HStack {
                    HTPickerView(selectedNumber: $party, upperLimit: 20, icon: "person.2.fill", iconLeading: true)
                        .onChange(of: party) {
                            calculateTip()
                        }
                    HTTextField(title: UIStrings.tipAmount, value: $tipAmount, isDisabled: true)
                    HTPickerView(selectedNumber: $tipPercent, upperLimit: 40, icon: "percent", iconLeading: false, initialValue: 15)
                        .onChange(of: tipPercent) {
                            calculateTip()
                        }
                }
                .padding(.horizontal)
                BillOutputView(tipPerPerson: $tipPerPerson, pricePerPerson: $pricePerPerson, totalBill: $totalBill)
                    .padding(.horizontal)
                Spacer()
                Button {
                    print("Calculate tip")
                    addTip()
                } label: {
                    Text("Confirm Tip")
                        .font(.HTBody20)
                        .fontWeight(.medium)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .foregroundStyle(Color(.systemBackground))
                        .background(.htGreen)
                        .appCornerRadius()
                }
                .padding()

                
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
            .appCornerRadius()
            .focused($isInputFocused)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(UIStrings.done) {
                        isInputFocused = false
                        calculateTip()
                    }
                }
            }
        }
    }
    
    private func calculateTip() {
        // Run any calculation or validation here
        guard let bill = Double(billAmount),
        let tipPercent = tipPercent,
        let party = party else { return }
        let tipAmountValue = bill * Double(tipPercent) / 100
        let total = bill + tipAmountValue
        let pricePerPersonValue = total / Double(party)
        let tipPerPersonValue = tipAmountValue / Double(party)

        totalBill = String(format: "%.2f", total)
        tipAmount = String(format: "%.2f", tipAmountValue)
        pricePerPerson = String(format: "%.2f", pricePerPersonValue)
        tipPerPerson = String(format: "%.2f", tipPerPersonValue)
    }

    private func addTip() {
        guard let bill = Double(billAmount),
              let tipPercent = tipPercent,
              let party = party else { return }
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
    }
}

#Preview {
    TipCalculationView()
}
