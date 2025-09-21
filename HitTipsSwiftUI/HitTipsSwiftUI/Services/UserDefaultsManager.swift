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
    
    // MARK: Helpers
    func incrementAdCount() {
        adCount += 1
        print("Ad count\(adCount), Ad frequency: \(adFrequency)")
    }
    
    func shouldShowAd() -> Bool {
        print("Should show ad? Ad count\(adCount), Ad frequency: \(adFrequency)")
        return adCount >= adFrequency
    }
    
    func resetAdCount() {
        print("Reset ad count: \(adCount)")
        adCount = 0
        print("Reset ad count: \(adCount)")
    }
    
    func adCountErrorMessage() -> String {
        return "Error: Ad count \(adCount), Ad frequency \(adFrequency)"
    }
}
