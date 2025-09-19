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
    var tip: Tip?
    var roast: String?
    // Existing published properties
    @Published var billAmount = "0.00"
    @Published var tipAmount: Double = 0.0
    @Published var tipPerPerson: Double = 0.0
    @Published var pricePerPerson: Double = 0.0
    @Published var totalBill: Double = 0.0
    @Published var party = 1
    @Published var tipPercent = 15
    @Published var showInvalidAmountAlert = false
    @Published var showTipDetailScreen = false
    @Published var isLoading = false
    @Published var loaderMessage = UIStrings.loading
    @Published var isTipReadyToShow = false

    private let apiService: APIService
    private let fireStoreManager: FirestoreManager
    private let context: ModelContext

    init(apiService: APIService = APIService(),
         fireStoreManager: FirestoreManager = FirestoreManager(),
         context: ModelContext) {
        self.apiService = apiService
        self.fireStoreManager = fireStoreManager
        self.context = context
        
        loadLastTipPercentage()  // <-- load saved value on init
    }
    
    var finalTipPercentageForTip: Int {
        guard let bill = Double(billAmount), bill > 0 else { return tipPercent }
        let adjustedTip = totalBill - bill
        let finalPercent = (adjustedTip / bill) * 100
        return Int(finalPercent.rounded())
    }
    
    // MARK: - Tip Calculation
    func calculateTip() {
        guard let bill = Double(billAmount) else { return }
        let tipValue = bill * Double(tipPercent) / 100
        let total = bill + tipValue
        
        saveLastTipPercentage()
        
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
        
        // Don't update percentage, else total bill won't be whole dollar
        let adjustedTip = roundedTotal - bill
        tipAmount = adjustedTip
        totalBill = roundedTotal
        tipPerPerson = adjustedTip / Double(party)
        pricePerPerson = roundedTotal / Double(party)
    }
    
    // MARK: - Save/Load Last Tip Percentage
    private func loadLastTipPercentage() {
        let request = FetchDescriptor<AppSettings>()
        do {
            if let settings = try context.fetch(request).first {
                tipPercent = settings.lastTipPercentage
            } else {
                tipPercent = 15
            }
        } catch {
            print("Failed to fetch last tip percentage:", error)
            tipPercent = 15
        }
    }
    
    private func saveLastTipPercentage() {
        let request = FetchDescriptor<AppSettings>()
        do {
            if let existing = try context.fetch(request).first {
                existing.lastTipPercentage = tipPercent
            } else {
                let settings = AppSettings(lastTipPercentage: tipPercent)
                context.insert(settings)
            }
            try context.save()
        } catch {
            print("Failed to save last tip percentage:", error)
        }
    }
    
    // MARK: - Validate & Add Tip
    func validateAndAddTip() {
        guard Double(billAmount) != nil else {
            showInvalidAmountAlert = true
            return
        }
        isLoading = true
        saveLastTipPercentage()
        fetchRoast()
    }
    
    private func fetchRoast() {
        loaderMessage = UIStrings.thinkingOfGoodRoast
        apiService.callFirebaseApi(prompt: "Roast a good tip I left at a restaurant", model: fireStoreManager.fetchAiModelToUserDefaults()) { [weak self] response in
            if let response = response,
               let self = self {
                self.loaderMessage = UIStrings.processingResponse
                self.roast = response
                self.addTip()
                self.isLoading = false
                self.isTipReadyToShow = true
                print(response)
            } else {
                self?.isLoading = false
                self?.showInvalidAmountAlert = true
            }
        }
    }
    
    private func addTip() {
        guard let bill = Double(billAmount),
              let roast = roast else { return }
        
        // Use the displayed tipAmount and totalBill (after rounding) instead of recalculating
        let newTip = Tip(
            roast: roast,
            billAmount: String(format: "%.2f", bill),
            totalBill: totalBill,
            date: Date(),
            party: party,
            pricePerPerson: pricePerPerson,
            tipPerPerson: tipPerPerson,
            tipAmount: tipAmount,
            tipPercentage: finalTipPercentageForTip
        )
        
        self.tip = newTip
        context.insert(newTip)
    }

    
    func formatBillAmount() {
        if let bill = Double(billAmount) {
            billAmount = String(format: "%.2f", bill)
        }
    }
}


