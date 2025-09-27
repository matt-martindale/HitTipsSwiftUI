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
        ZStack {
            // Gradient background
            LinearGradient(colors: [Color.purple, Color.blue],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer(minLength: 20)
                
                // App Icon / Logo
                Image("HitTipsLogoTransparent") // replace with your asset
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .shadow(radius: 10)
                
                // Hero Text
                VStack(spacing: 8) {
                    Text("Unlock Premium")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                    
                    Text("3-Day Free Trial • Cancel Anytime")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                
                // Feature List
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "theatermasks.fill",
                               text: "All Premium Personas")
                    FeatureRow(icon: "nosign",
                               text: "Ad-Free Experience")
                    FeatureRow(icon: "brain.head.profile",
                               text: "Smarter AI Model")
                    FeatureRow(icon: "gift.fill",
                               text: "Seasonal Unlocks (Santa, Dracula & more)")
                    FeatureRow(icon: "star.fill",
                               text: "Priority Access to New Features")
                }
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                
                Spacer()
                
                // Pricing + CTA
                VStack(spacing: 12) {
                    if let offering = subscriptionManager.offerings?.current,
                       let pkg = offering.availablePackages.first {
                        Text(subscriptionManager.pricingDescription(for: pkg))
                            .font(.headline)
                            .foregroundStyle(.white)
                        
                        Button(action: {
                            // trigger subscription purchase
                            subscriptionManager.purchase(pkg)
                        }) {
                            Text("Start Free Trial")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .foregroundStyle(Color.blue)
                                .cornerRadius(14)
                        }
                    } else {
                        // Fallback while offerings are loading
                        ProgressView("Loading plans…")
                            .foregroundStyle(.white)
                    }
                }
                
                // Restore + Legal
                VStack(spacing: 4) {
                    Button("Restore Purchases") {
                        // handle restore
                        subscriptionManager.restorePurchases()
                    }
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.9))
                    
                    Text("Cancel anytime. Subscription renews automatically at $3.99/month unless canceled at least 24 hours before the end of trial.")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
    }
}


struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.htBlue)
                .frame(width: 24, height: 24)
            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    SubscriptionView()
        .environmentObject(SubscriptionManager())
}
