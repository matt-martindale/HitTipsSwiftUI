//
//  SubscriptionView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/26/25.
//

import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedURL: URL?
    @State private var showToast = false
    
    var body: some View {
        ZStack {
            background
            content
            if subscriptionManager.isLoading {
                SpinnerView(text: "Processing…")
            }
            // 👇 Toast overlay
            if showToast, let success = subscriptionManager.successMessage {
                VStack {
                    ToastView(message: success)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.3), value: showToast)
            }
        }
        .onChange(of: subscriptionManager.successMessage) { newValue in
            if newValue != nil {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        showToast = false
                    }
                    subscriptionManager.successMessage = nil
                    
                    // 👇 Dismiss sheet after toast finishes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        dismiss()
                    }
                }
            }
        }
        .sheet(item: $selectedURL) { url in
            SafariView(url: url)
        }
        .alert("Error", isPresented: errorBinding) {
            Button("OK", role: .cancel) {
                subscriptionManager.errorMessage = nil
            }
        } message: {
            if let message = subscriptionManager.errorMessage {
                Text(message)
            }
        }
    }
}

// MARK: - Components
private extension SubscriptionView {
    var background: some View {
        LinearGradient(colors: [Color.purple, Color.blue],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
    
    var content: some View {
        VStack(spacing: 32) {
            Spacer(minLength: 20)
            
            logo
            titleSection
            featureList
            Spacer()
            pricingSection
            restoreAndLegal
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
    
    var logo: some View {
        Image("HitTipsLogoTransparent")
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
    }
    
    var titleSection: some View {
        VStack(spacing: 8) {
            Text(UIStrings.unlockPremium)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            
            Text(UIStrings.paywallSubtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
    }
    
    var featureList: some View {
        VStack(alignment: .leading, spacing: 16) {
            FeatureRow(icon: "theatermasks.fill", text: UIStrings.premiumPerk1)
            FeatureRow(icon: "nosign", text: UIStrings.premiumPerk2)
            FeatureRow(icon: "brain.head.profile", text: UIStrings.premiumPerk3)
            FeatureRow(icon: "gift.fill", text: UIStrings.premiumPerk4)
            FeatureRow(icon: "star.fill", text: UIStrings.premiumPerk5)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
    
    var pricingSection: some View {
        VStack(spacing: 12) {
            if let offering = subscriptionManager.offerings?.current,
               let pkg = offering.availablePackages.first {
                Text(subscriptionManager.pricingDescription(for: pkg))
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Button {
                    subscriptionManager.purchase(pkg)
                } label: {
                    Text(UIStrings.paywallCTA)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .foregroundStyle(Color.blue)
                        .cornerRadius(14)
                }
            } else {
                ProgressView(UIStrings.paywallLoading)
                    .foregroundStyle(.white)
            }
        }
    }
    
    var restoreAndLegal: some View {
        VStack(spacing: 4) {
            HStack {
                Button(UIStrings.restorePurchases) {
                    subscriptionManager.restorePurchases()
                }
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.9))
                
                Text("•")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.8))
                
                Button(UIStrings.termsOfUse) {
                    selectedURL = URL(string: UIStrings.termsOfUseURL)
                }
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.9))
                
                Text("•")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.8))
                
                Button(UIStrings.privacyPolicy) {
                    selectedURL = URL(string: UIStrings.privacyPolicyURL)
                }
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.9))
            }
            
            Text(String(format: UIStrings.footerTerms,
                        subscriptionManager.price ?? "$3.99"))
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
        }
    }
    
    // Custom binding for error alert
    var errorBinding: Binding<Bool> {
        Binding(
            get: { subscriptionManager.errorMessage != nil },
            set: { if !$0 { subscriptionManager.errorMessage = nil } }
        )
    }
}

// MARK: - Spinner Overlay
struct SpinnerView: View {
    var text: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                ProgressView()
                Text(text)
                    .font(.headline)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

// MARK: - Feature Row
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
