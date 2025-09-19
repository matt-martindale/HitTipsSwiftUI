//
//  AdManager.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/14/25.
//

import Foundation

enum AdEnvironment {
    case test, production
}

struct HTAdManager {
    static var adEnvironment: AdEnvironment { .test } // Set which environment to fetch Ad Units
    
    // Ad Units
    static var homeAdBanner: String {
        adEnvironment == .test ? "ca-app-pub-3940256099942544/2934735716" : "ca-app-pub-1303232766034898/6482684616"
    }
    static var historyAdBanner: String {
        adEnvironment == .test ? "ca-app-pub-3940256099942544/2934735716" : "ca-app-pub-1303232766034898/1482473520"
    }
    static var homeInterstitialAd: String {
        adEnvironment == .test ? "ca-app-pub-3940256099942544/4411468910" : "ca-app-pub-1303232766034898/8773257291"
    }
    
    // Ad count management
    func incrementAdCount() {
        var adCount = UserDefaultsManager.shared.fetchAdCountFromUserDefaults()
        adCount += 1
        UserDefaultsManager.shared.updateAdCountToUserDefaults(adCount)
    }
    
    func shouldShowAd() -> Bool {
        let adCount = UserDefaultsManager.shared.fetchAdCountFromUserDefaults()
        let adFrequency = UserDefaultsManager.shared.fetchAdFrequencyFromUserDefaults()
        return adCount >= adFrequency
    }
    
    func resetAdCount() {
        UserDefaultsManager.shared.updateAdCountToUserDefaults(0)
    }
}
