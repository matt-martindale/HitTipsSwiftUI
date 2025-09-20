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
                print("✅ Interstitial loaded")
            } else if let error = error {
                print("❌ Failed to load interstitial: \(error.localizedDescription)")
                self.isAdReady = false
            }
        }
    }

    func showAd(from root: UIViewController, onDismiss: @escaping () -> Void) {
        guard let interstitial = interstitial else {
            print("⚠️ Ad not ready")
            onDismiss()
            return
        }

        print("Presenting interstitial")
        self.onAdDismissed = onDismiss

        DispatchQueue.main.async {
            interstitial.present(from: root)
            self.interstitial = nil
            self.isAdReady = false
        }
    }

    // Delegate
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("ℹ️ Interstitial dismissed")
        Task { @MainActor in
            self.onAdDismissed?()
            self.onAdDismissed = nil
        }
        loadAd() // Preload next ad
    }

}

