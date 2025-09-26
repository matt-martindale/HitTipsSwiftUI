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
}

extension SubscriptionPeriod {
    var durationTitle: String {
        switch self.unit {
        case .day: return "day"
        case .week: return "week"
        case .month: return "month"
        case .year: return "year"
        default: return "Unknown"
        }
    }
    
    var periodTitle: String {
        let periodString = "\(self.value) \(self.durationTitle)"
        let pluralized = self.value > 1 ? periodString + "s" : periodString
        return pluralized
    }
}
