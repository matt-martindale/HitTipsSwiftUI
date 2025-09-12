//
//  TipCalculationViewModel.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/7/25.
//

import SwiftData
import FirebaseFunctions
import SwiftUI

@MainActor
class TipCalculationViewModel: ObservableObject {
    @Published var billAmount = "0.00"
    @Published var tipAmount: Double = 0.0
    @Published var tipPerPerson: Double = 0.0
    @Published var pricePerPerson: Double = 0.0
    @Published var totalBill: Double = 0.0
    @Published var party = 1
    @Published var tipPercent = 15
    @Published var showInvalidAmountAlert = false
    
    private let apiService: APIService
    private let context: ModelContext
    
    init(apiService: APIService = APIService(), context: ModelContext) {
        self.apiService = apiService
        self.context = context
    }
    
    func calculateTip() {
        guard let bill = Double(billAmount) else { return }
        let tipValue = bill * Double(tipPercent) / 100
        let total = bill + tipValue
        
        tipAmount = tipValue
        totalBill = total
        tipPerPerson = tipValue / Double(party)
        pricePerPerson = total / Double(party)
    }
    
    func applyRounding(_ action: ButtonAction) {
        guard let bill = Double(billAmount) else { return }
        let rawTip = bill * Double(tipPercent) / 100
        let rawTotal = bill + rawTip
        
        let roundedTotal: Double
        switch action {
        case .roundUp: roundedTotal = ceil(rawTotal)
        case .roundDown: roundedTotal = floor(rawTotal)
        }
        
        let adjustedTip = roundedTotal - bill
        tipAmount = adjustedTip
        totalBill = roundedTotal
        tipPerPerson = adjustedTip / Double(party)
        pricePerPerson = roundedTotal / Double(party)
    }
    
    func validateAndAddTip() {
        guard Double(billAmount) != nil else {
            showInvalidAmountAlert = true
            return
        }
        addTip()
    }
    
    private func addTip() {
        guard let bill = Double(billAmount) else { return }
        let tipValue = bill * Double(tipPercent) / 100
        let total = bill + tipValue
        
        let newTip = Tip(
            billAmount: String(format: "%.2f", bill),
            totalBill: total,
            date: Date(),
            party: party,
            pricePerPerson: total / Double(party),
            tipPerPerson: tipValue / Double(party),
            tipAmount: tipValue,
            tipPercentage: tipPercent
        )
        
        apiService.callFirebaseApi { response in
            if let response = response {
                print(response)
            }
        }
        
        context.insert(newTip)
    }
    
    func formatBillAmount() {
        if let bill = Double(billAmount) {
            billAmount = String(format: "%.2f", bill)
        }
    }
}

