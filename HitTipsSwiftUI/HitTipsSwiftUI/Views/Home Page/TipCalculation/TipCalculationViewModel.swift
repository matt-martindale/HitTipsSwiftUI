//
//  TipCalculationViewModel.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/7/25.
//

import CoreData
import FirebaseFunctions
import SwiftUI
import GoogleMobileAds

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
    @Published var alertTitle: String? = nil
    @Published var alertMessage: String? = nil
    
    private var context: NSManagedObjectContext
    private let adManager = InterstitialAdManager()
    private let roastService: RoastProviding
    @ObservedObject var roastSettings: RoastSettings
    
    init(context: NSManagedObjectContext,
         roastService: RoastProviding,
         roastSettings: RoastSettings) {
        self.context = context
        self.roastService = roastService
        self.roastSettings = roastSettings
        loadLastTipPercentage()
        adManager.loadAd()
    }
    
    func setContext(_ context: NSManagedObjectContext) {
            self.context = context
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
        
        roastSettings.tipTier = determineTipTier()
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
        
        roastSettings.tipTier = determineTipTier()
    }
    
    private func determineTipTier() -> TipTier {
            switch tipPercent {
            case 0...10: return TipTier.terrible
            case 11...19: return TipTier.bad
            case 20...29: return TipTier.decent
            case 30...99: return TipTier.good
            default: return TipTier.bad
            }
        }
    
    // MARK: - Save/Load Last Tip Percentage
    private func loadLastTipPercentage() {
        let request: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        do {
            if let settings = try context.fetch(request).first {
                tipPercent = Int(settings.lastTipPercentage)
            } else {
                tipPercent = 15
            }
        } catch {
            print("HTApp: Failed to fetch last tip percentage:", error)
            tipPercent = 15
        }
    }

    private func saveLastTipPercentage() {
        let request: NSFetchRequest<AppSettings> = AppSettings.fetchRequest()
        do {
            if let existing = try context.fetch(request).first {
                existing.lastTipPercentage = Int32(tipPercent)
            } else {
                let settings = AppSettings(context: context)
                settings.id = UUID()
                settings.lastTipPercentage = Int32(tipPercent)
            }
            try context.save()
        } catch {
            print("HTApp: Failed to save last tip percentage:", error)
        }
    }
    
    // MARK: - Validate & Add Tip
    func validateAndAddTip() {
        guard Double(billAmount) != nil else {
            alertTitle = UIStrings.invalidAmount
            alertMessage = UIStrings.enterValidAmount
            return
        }
        isLoading = true
        loaderMessage = UIStrings.randomFetchingRoastArray
        saveLastTipPercentage()
        
        roastService.fetchRoast(settings: roastSettings) { [weak self] response in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                if let response = response {
                    self.loaderMessage = UIStrings.processingResponse
                    self.roast = response
                    
                    let newTip = self.makeTip(roast: response)
                    self.tip = newTip
                    
                    do {
                        try self.context.save()   // ✅ save to Core Data
                        UserDefaultsManager.shared.incrementAdCount()
                        self.handleAdAndSheet()
                    } catch {
                        print("HTApp: Failed to save tip:", error)
                        self.alertTitle = "Save Failed"
                        self.alertMessage = error.localizedDescription
                    }
                    
                } else {
                    self.alertTitle = UIStrings.ssww
                    self.alertMessage = UIStrings.pleaseTryAgain
                }
            }
        }
    }
    
    private func makeTip(roast: String) -> Tip {
        let bill = Double(billAmount) ?? 0
        
        let newTip = Tip(context: context)
        newTip.id = UUID()
        newTip.roast = roast
        newTip.billAmount = String(format: "%.2f", bill)
        newTip.totalBill = totalBill
        newTip.date = Date()
        newTip.party = Int32(party)
        newTip.pricePerPerson = pricePerPerson
        newTip.tipPerPerson = tipPerPerson
        newTip.tipAmount = tipAmount
        newTip.tipPercentage = Int32(finalTipPercentage)
        newTip.isFavorite = false
        newTip.roastStyle = roastSettings.roastStyle.rawValue
        newTip.tipTier = roastSettings.tipTier.rawValue
        if let persona = roastSettings.selectedPersonaID {
            newTip.personaID = persona
        }
        
        if let persona = newTip.persona {
            print("HTApp: This tip used persona: \(persona.name)")
        }
        
        return newTip
    }

    
    var finalTipPercentage: Int {
            guard let bill = Double(billAmount), bill > 0 else { return tipPercent }
            let adjustedTip = totalBill - bill
            let finalPercent = (adjustedTip / bill) * 100
            return Int(finalPercent.rounded())
        }
    
//    private func addTip() {
//        guard let bill = Double(billAmount),
//              let roast = roast else { return }
//        
//        let newTip = Tip(context: context)
//        newTip.id = UUID()
//        newTip.roast = roast
//        newTip.billAmount = String(format: "%.2f", bill)
//        newTip.totalBill = totalBill
//        newTip.date = Date()
//        newTip.party = Int32(party)
//        newTip.pricePerPerson = pricePerPerson
//        newTip.tipPerPerson = tipPerPerson
//        newTip.tipAmount = tipAmount
//        newTip.tipPercentage = Int32(finalTipPercentageForTip)
//        newTip.isFavorite = false
//        
//        // ✅ Attach RoastSettings snapshot
//        let settings = RoastSettings(context: context)
//        settings.roastStyle = roastSettings.roastStyle
//        settings.tipTier = roastSettings.tipTier
//        newTip.roastSettings = settings
//        
//        self.tip = newTip
//        
//        do {
//            try context.save()   // persist changes
//            UserDefaultsManager.shared.incrementAdCount()
//        } catch {
//            print("HTApp: Failed to save tip:", error)
//            alertTitle = "Save Failed"
//            alertMessage = error.localizedDescription
//        }
//    }
    
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
            adManager.loadAd()
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
}
