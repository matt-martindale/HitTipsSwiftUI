//
//  InterstitialAdManager.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/14/25.
//

import GoogleMobileAds
import UIKit
import SwiftUI

class InterstitialAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    private var interstitial: InterstitialAd?
    private let adUnitID = HTAdManager.homeInterstitialAd
    @Published var isAdReady = false
    private var onAdDismissed: (() -> Void)?

    func loadAd() {
        InterstitialAd.load(with: adUnitID, request: Request()) { [weak self] ad, error in
            guard let self = self else { return }
            if let ad = ad {
                self.interstitial = ad
                ad.fullScreenContentDelegate = self
                self.isAdReady = true
                print("HTApp: ✅ Interstitial loaded")
            } else if let error = error {
                print("HTApp: ❌ Failed to load interstitial: \(error.localizedDescription)")
                self.isAdReady = false
            }
        }
    }

    func showAd(from root: UIViewController, isPremiumUser: Bool, onDismiss: @escaping () -> Void) {
        guard !isPremiumUser else {
            print("HTApp: Premium User, don't show ad")
            onDismiss()
            return
        }
        
        guard let interstitial = interstitial else {
            print("HTApp: ⚠️ Ad not ready")
            onDismiss()
            return
        }

        print("HTApp: Presenting interstitial")
        self.onAdDismissed = onDismiss

        DispatchQueue.main.async {
            interstitial.present(from: root)
            self.interstitial = nil
            self.isAdReady = false
        }
    }

    // Delegate
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("HTApp: ℹ️ Interstitial dismissed")
        Task { @MainActor in
            self.onAdDismissed?()
            self.onAdDismissed = nil
        }
        loadAd() // Preload next ad
    }

}

