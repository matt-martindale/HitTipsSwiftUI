//
//  SubscriptionView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/26/25.
//

import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager

    var body: some View {
        VStack {
            if let offering = subscriptionManager.offerings?.current {
                ForEach(offering.availablePackages, id: \.identifier) { pkg in
                    Button("Buy \(pkg.storeProduct.localizedTitle) \(pkg.storeProduct.subscriptionPeriod?.periodTitle ?? "")") {
                        subscriptionManager.purchase(pkg)
                    }
                }
            }
        }
    }
}

#Preview {
    SubscriptionView()
}
