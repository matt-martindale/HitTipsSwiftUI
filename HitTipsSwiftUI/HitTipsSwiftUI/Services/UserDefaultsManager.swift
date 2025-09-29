//
//  UserDefaultsManager.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/19/25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    
    // MARK: Keys
    private let aiModelKey = "aiModel"
    private let adFrequencyKey = "adFrequency"
    private let adCountKey = "adCount"
    private let rateAppKey = "rateApp"
    
    private init() {}
    
    // MARK: Computed properties
    var aiModel: String {
        get { userDefaults.string(forKey: aiModelKey) ?? "gpt-4o-mini" }
        set { userDefaults.set(newValue, forKey: aiModelKey) }
    }
    
    var adCount: Int {
        get { userDefaults.integer(forKey: adCountKey) }
        set { userDefaults.set(newValue, forKey: adCountKey) }
    }
    
    var adFrequency: Int {
        get {
            let stored =  userDefaults.integer(forKey: adFrequencyKey)
            return stored == 0 ? 3 : stored
        }
        set { userDefaults.set(newValue, forKey: adFrequencyKey) }
    }
    
    var rateAppCount: Int {
        get { userDefaults.integer(forKey: rateAppKey) }
        set { userDefaults.set(newValue, forKey: rateAppKey) }
    }
    
    // MARK: Helpers
    func incrementAdCount() {
        adCount += 1
        print("HTApp: Ad count: \(adCount), Ad frequency: \(adFrequency)")
        incrementTipCount()
    }
    
    func shouldShowAd() -> Bool {
        return adCount >= adFrequency
    }
    
    func resetAdCount() {
        adCount = 0
        print("HTApp: Reset ad count: \(adCount)")
    }
    
    func adCountErrorMessage() -> String {
        return "HTApp: Error: Ad count \(adCount), Ad frequency \(adFrequency)"
    }
    
    func incrementTipCount() {
        rateAppCount += 1
        print("HTApp: Rate app count \(rateAppCount)")
        }
    
    func shouldShowRateApp() -> Bool {
        if [5, 15, 30].contains(rateAppCount) {
            return true
        }
        return false
    }
}
