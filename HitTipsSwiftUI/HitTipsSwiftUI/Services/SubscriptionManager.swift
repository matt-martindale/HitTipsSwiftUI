//
//  SubscriptionManager.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/26/25.
//

import Foundation
import RevenueCat

@MainActor
class SubscriptionManager: ObservableObject {
    @Published var offerings: Offerings?
    @Published var isPremiumUser = false
    @Published var price: String?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?

    init() {
        fetchOfferings()
        refreshCustomerInfo()
    }
    
    func refreshCustomerInfo() {
        Purchases.shared.getCustomerInfo { info, error in
            if let info = info {
                if info.entitlements["Premium Features"]?.isActive == true {
                    self.isPremiumUser = true
                } else {
                    self.isPremiumUser = false
                }
            }
        }
    }

    func fetchOfferings() {
        Purchases.shared.getOfferings { offerings, error in
            if let offerings = offerings {
                self.offerings = offerings
                
                if let package = offerings.current?.availablePackages.first {
                    self.price = package.storeProduct.localizedPriceString
                }
            }
        }
    }

    func purchase(_ package: Package) {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        Purchases.shared.purchase(package: package) { [weak self] result, customerInfo, error, userCancelled in
            self?.isLoading = false
            if let error = error {
                self?.errorMessage = "Purchase failed: \(error.localizedDescription)"
            } else if let info = customerInfo,
               info.entitlements["Premium Features"]?.isActive == true {
                self?.isPremiumUser = true
                self?.successMessage = "✅ Premium unlocked!"
            }
        }
    }
    
    func restorePurchases() {
        isLoading = true
        errorMessage = nil
        successMessage = nil
        Purchases.shared.restorePurchases { [weak self] customerInfo, error in
            self?.isLoading = false
            if let error = error {
                self?.errorMessage = "Restore failed: \(error.localizedDescription)"
            } else if let customerInfo = customerInfo {
                if customerInfo.entitlements.active.isEmpty {
                    self?.errorMessage = "No active subscription found."
                } else {
                    print("Restored successfully! Active entitlements: \(customerInfo.entitlements.active.keys)")
                    self?.isPremiumUser = true
                    self?.successMessage = "✅ Purchases restored!"
                }
            }
        }
    }
    
    func pricingDescription(for pkg: Package) -> String {
        let product = pkg.storeProduct
        let price = product.localizedPriceString
        let unit = product.subscriptionPeriod?.durationTitle ?? ""
        
        if let trial = product.introductoryDiscount {
            let trialValue = trial.subscriptionPeriod.value
            let trialUnit = trial.subscriptionPeriod.unit.localized(for: trialValue)
            
            return "Only \(price)/\(unit) after \(trialValue)-\(trialUnit) trial"
        } else {
            return "Only \(price)/\(unit)"
        }
    }

    func ctaText(for pkg: Package) -> String {
        let product = pkg.storeProduct
        if product.introductoryDiscount != nil {
            return "Start Free Trial"
        } else {
            return "Subscribe Now"
        }
    }

    
}

extension SubscriptionPeriod.Unit {
    func localized(for value: Int) -> String {
        switch self {
        case .day: return "day"
        case .week: return "week"
        case .month: return "month"
        case .year: return "year"
        @unknown default: return ""
        }
    }
}

extension SubscriptionPeriod {
    var durationTitle: String {
        let value = self.value
        let unit = self.unit.localized(for: value)
        return "\(unit)"
    }
}
