//
//  BannerAdView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/12/25.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = rootViewController()
        bannerView.load(Request())
        return bannerView
    }

    func updateUIView(_ uiView: BannerView, context: Context) { }

    private func rootViewController() -> UIViewController? {
        // robust way to find rootViewController in scenes
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController
    }
}


#Preview {
    BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
}
