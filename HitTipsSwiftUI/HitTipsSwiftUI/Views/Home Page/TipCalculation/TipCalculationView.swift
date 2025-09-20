//
//  TipCalculationView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData
import GoogleMobileAds

enum FocusedField {
    case billAmount, party, tipPercent
}

struct TipCalculationView: View {
    @StateObject private var viewModel: TipCalculationViewModel
    @StateObject private var adManager = InterstitialAdManager()
    @FocusState private var focusedField: FocusedField?

    // Track if we've already shown the sheet for the current tip
    @State private var hasShownTip = false

    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: TipCalculationViewModel(context: context))
    }

    var body: some View {
        LoaderView(isLoading: $viewModel.isLoading, message: $viewModel.loaderMessage) {
            NavigationStack {
                VStack {
                    billAmountField
                    partyTipPickers
                    billOutputView
                    Spacer()
                    confirmButton
                }
                .padding(.horizontal)
                .appCornerRadius()
                .toolbar { keyboardToolbar }
                .alert(UIStrings.invalidAmount, isPresented: $viewModel.showInvalidAmountAlert) {
                    Button(UIStrings.ok, role: .cancel) { }
                } message: {
                    Text(UIStrings.enterValidAmount)
                }
            }
            // Tip Detail Sheet
            .sheet(isPresented: $viewModel.showTipDetailScreen) {
                if let tip = viewModel.tip {
                    TipDetailView(tip: tip, entryPoint: .sheet)
                        .ignoresSafeArea()     // Take the full screen bounds
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            // Show sheet automatically once a Tip exists
            .onChange(of: viewModel.tip) { newTip in
                guard let _ = newTip else { return }
                
                // Always show sheet for new Tip objects
                if !hasShownTip {
                    viewModel.showTipDetailScreen = true
                    hasShownTip = true
                } else {
                    // New tip object, reset flag
                    hasShownTip = false
                    viewModel.showTipDetailScreen = true
                    hasShownTip = true
                }
            }

            .onAppear {
                adManager.loadAd()
                // In case tip already exists when view appears
                if viewModel.tip != nil && !hasShownTip {
                    viewModel.showTipDetailScreen = true
                    hasShownTip = true
                }
            }
        }
    }

    // MARK: - Subviews

    private var billAmountField: some View {
        HTTextField(title: UIStrings.billAmountCap, value: $viewModel.billAmount, keyboardType: .decimalPad)
            .focused($focusedField, equals: .billAmount)
            .onChange(of: focusedField) { newFocus in
                if newFocus == .billAmount && viewModel.billAmount == "0.00" {
                    viewModel.billAmount = ""
                } else if newFocus != .billAmount && viewModel.billAmount.isEmpty {
                    viewModel.billAmount = "0.00"
                }
            }
            .padding(.top)
    }

    private var partyTipPickers: some View {
        HStack {
            HTPickerView(selectedNumber: $viewModel.party, upperLimit: 99, icon: "person.2.fill", iconLeading: true)
                .focused($focusedField, equals: .party)
                .onChange(of: viewModel.party) { _ in viewModel.calculateTip() }

            AnimatedNumberView(value: viewModel.tipAmount, title: UIStrings.tipAmountCap, hasBackground: false)

            HTPickerView(selectedNumber: $viewModel.tipPercent, upperLimit: 99, icon: "percent", iconLeading: false)
                .focused($focusedField, equals: .tipPercent)
                .onChange(of: viewModel.tipPercent) { _ in viewModel.calculateTip() }
        }
    }

    private var billOutputView: some View {
        BillOutputView(
            tipPerPerson: $viewModel.tipPerPerson,
            pricePerPerson: $viewModel.pricePerPerson,
            totalBill: $viewModel.totalBill
        ) { action in
            viewModel.applyRounding(action)
        }
    }

    private var confirmButton: some View {
        Button {
            viewModel.validateAndAddTip()
            showTipAfterAd()
        } label: {
            Text(UIStrings.confirmTip)
                .font(.HTBody20)
                .fontWeight(.medium)
                .padding(.vertical, 8)
                .padding(.horizontal)
                .foregroundStyle(Color(.systemBackground))
                .background(.htGreen)
                .appCornerRadius()
        }
        .padding()
    }

    private var keyboardToolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button(UIStrings.done) {
                viewModel.formatBillAmount()
                focusedField = nil
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.calculateTip()
                }
            }
        }
    }

    // MARK: - Ad Presentation

    private func showTipAfterAd() {
        if UserDefaultsManager.shared.shouldShowAd(), adManager.isAdReady {
            // Present the ad; sheet will show automatically via tip change
            if let root = UIApplication.shared.topMostViewController {
                adManager.showAd(from: root) {
                    UserDefaultsManager.shared.resetAdCount()
                }
            }
        }
    }
}

// MARK: - UIApplication Extension for Top ViewController
extension UIApplication {
    var topMostViewController: UIViewController? {
        let keyWindow = connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        var topController = keyWindow?.rootViewController
        while let presented = topController?.presentedViewController {
            topController = presented
        }
        return topController
    }
}
