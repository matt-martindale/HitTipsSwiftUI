//
//  UserDefaultsManager.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/19/25.
//

import Foundation

struct UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard
    private let aiModelString = "aiModel"
    private let adFrequencyString = "adFrequency"
    private let adCountString = "adCount"
    
    private init() {}
    
    func updateAiModelToUserDefaults(_ aiModel: String) {
        userDefaults.set(aiModel, forKey: aiModelString)
    }
    
    func updateAdFrequencyToUserDefaults(_ adFrequency: Int) {
        userDefaults.set(adFrequency, forKey: adFrequencyString)
    }
    
    func updateAdCountToUserDefaults(_ adCount: Int) {
        userDefaults.set(adCount, forKey: adCountString)
    }
    
    func fetchAiModelFromUserDefaults() -> String {
        userDefaults.value(forKey: aiModelString) as? String ?? "gpt-4o-mini"
    }
    
    func fetchAdFrequencyFromUserDefaults() -> Int {
        (userDefaults.value(forKey: adFrequencyString) as? Int) ?? 3
    }
    
    func fetchAdCountFromUserDefaults() -> Int {
        (userDefaults.value(forKey: adCountString) as? Int) ?? 0
    }
}
