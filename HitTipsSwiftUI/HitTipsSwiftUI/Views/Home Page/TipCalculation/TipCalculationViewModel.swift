//
//  TipCalculationViewModel.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/7/25.
//

import SwiftData
import FirebaseFunctions
import SwiftUI
import GoogleMobileAds

enum TipTier: String {
    case terrible, bad, decent, good
}

@MainActor
class TipCalculationViewModel: ObservableObject {
    var tip: Tip?
    var roast: String?

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

    private let apiService: APIService
    private let fireStoreManager: FirestoreManager
    private let context: ModelContext
    private let adManager = InterstitialAdManager()

    init(apiService: APIService = APIService(),
         fireStoreManager: FirestoreManager = FirestoreManager(),
         context: ModelContext) {
        self.apiService = apiService
        self.fireStoreManager = fireStoreManager
        self.context = context

        loadLastTipPercentage()
        adManager.loadAd()
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
        apiService.callFirebaseApi(prompt: fetchPrompt()) { [weak self] response in
            guard let self = self else { return }

            if let response = response {
                self.loaderMessage = UIStrings.processingResponse
                self.roast = response
                self.addTip()
                self.isLoading = false
                self.handleAdAndSheet()
            } else {
                self.isLoading = false
                self.showInvalidAmountAlert = true
            }
        }
    }

    private func addTip() {
        guard let bill = Double(billAmount),
              let roast = roast else { return }

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

        // Increment ad counter when a tip is successfully added
        UserDefaultsManager.shared.incrementAdCount()
    }

    // MARK: - Ad + Sheet Coordination
    private func handleAdAndSheet() {
        if UserDefaultsManager.shared.shouldShowAd(),
           adManager.isAdReady,
           let root = UIApplication.shared.connectedScenes
               .compactMap({ $0 as? UIWindowScene })
               .flatMap({ $0.windows })
               .first(where: { $0.isKeyWindow })?.rootViewController {
            
            adManager.showAd(from: root) {
                // Ad dismissed → reset ad count and show sheet
                UserDefaultsManager.shared.resetAdCount()
                DispatchQueue.main.async {
                    self.showTipDetailScreen = true
                }
            }
        } else {
            // No ad → show sheet immediately
            DispatchQueue.main.async {
                self.showTipDetailScreen = true
            }
        }
    }


    // MARK: - Helpers
    func formatBillAmount() {
        if let bill = Double(billAmount) {
            billAmount = String(format: "%.2f", bill)
        }
    }

    func fetchPrompt() -> String {
        switch tipPercent {
        case 0...10:
            TipTier.terrible.rawValue
        case 11...19:
            TipTier.bad.rawValue
        case 20...29:
            TipTier.decent.rawValue
        case 30...99:
            TipTier.good.rawValue
        default:
            TipTier.bad.rawValue
        }
    }
}
