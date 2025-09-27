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

    init() {
        fetchOfferings()
        refreshCustomerInfo()
    }
    
    func refreshCustomerInfo() {
        Purchases.shared.getCustomerInfo { info, error in
            if let info = info {
                self.isPremiumUser = info.entitlements["Premium Features"]?.isActive == true
            }
//            if let info = info {
//                print("RevenueCat App User ID: \(Purchases.shared.appUserID)")
//                print("Entitlements: \(info.entitlements.active.keys)") // shows active entitlements
//                if info.entitlements["Premium Features"]?.isActive == true {
//                    self.isPremiumUser = true
//                    print("✅ User has premium access")
//                } else {
//                    print("❌ User does not have premium access")
//                }
//            }
        }
    }

    func fetchOfferings() {
        Purchases.shared.getOfferings { offerings, error in
            if let offerings = offerings {
                self.offerings = offerings
            }
        }
    }

    func purchase(_ package: Package) {
        Purchases.shared.purchase(package: package) { result, customerInfo, error, userCancelled in
            if let info = customerInfo,
               info.entitlements["Premium Features"]?.isActive == true {
                self.isPremiumUser = true
            }
        }
    }
    
    func restorePurchases() {
        Purchases.shared.restorePurchases { customerInfo, error in
            if let error = error {
                print("Restore failed: \(error.localizedDescription)")
            } else if let customerInfo = customerInfo {
                if customerInfo.entitlements.active.isEmpty {
                    print("No active subscriptions found.")
                } else {
                    print("Restored successfully! Active entitlements: \(customerInfo.entitlements.active.keys)")
                    // You can update your app state here, e.g. unlock premium
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
            
            return "Only \(price)/\(unit)after \(trialValue)-\(trialUnit) trial"
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
