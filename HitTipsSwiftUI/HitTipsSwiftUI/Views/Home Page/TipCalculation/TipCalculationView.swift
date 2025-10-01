//
//  TipCalculationView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import CoreData

enum FocusedField {
    case billAmount, party, tipPercent
}

struct TipCalculationView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: TipCalculationViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(roastSettings: RoastSettings, subscriptionManager: SubscriptionManager) {
        _viewModel = StateObject(
            wrappedValue: TipCalculationViewModel(
                context: PersistenceController.shared.container.viewContext, // placeholder, replaced in body
                roastService: RoastService(apiService: APIService()),
                roastSettings: roastSettings,
                subscriptionManager: subscriptionManager
            )
        )
    }
    
    var body: some View {
        LoaderView(isLoading: $viewModel.isLoading, message: $viewModel.loaderMessage) {
            NavigationStack {
                ZStack {
                    // Tap layer behind content
                    Color.clear
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture { dismissKeyboardAndCalculate() }
                    
                    VStack {
                        billAmountField
                        partyTipPickers
                        billOutputView
                        Spacer().frame(height: 20)
                        confirmButton
                        Spacer()
                    }
                    .padding(.horizontal)
                    .appCornerRadius()
                    .alert(
                        viewModel.alertTitle ?? "",
                        isPresented: Binding(
                            get: { viewModel.alertTitle != nil },
                            set: { if !$0 {
                                viewModel.alertTitle = nil
                                viewModel.alertMessage = nil
                            }}
                        )
                    ) {
                        Button(UIStrings.ok, role: .cancel) {
                            viewModel.alertTitle = nil
                            viewModel.alertMessage = nil
                        }
                    } message: {
                        if let message = viewModel.alertMessage {
                            Text(message)
                        }
                    }
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 1).onChanged { _ in
                        if focusedField != nil { dismissKeyboardAndCalculate() }
                    }
                )
            }
            // Tip Detail Sheet controlled by VM
            .sheet(isPresented: $viewModel.showTipDetailScreen) {
                if let tip = viewModel.tip {
                    TipDetailView(tip: tip, entryPoint: .sheet)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onAppear {
            viewModel.setContext(context)
            viewModel.calculateTip()
        }
        .onReceive(NotificationCenter.default.publisher(for: .keyboardDoneTapped)) { _ in
            viewModel.formatBillAmount()
            // Defer to ensure any focus-driven mutations (like setting "0.00") land first
            focusedField = nil
            DispatchQueue.main.async {
                viewModel.calculateTip()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var billAmountField: some View {
        HTTextField(
            title: UIStrings.billAmountCap,
            value: $viewModel.billAmount,
            keyboardType: .decimalPad
        )
        .focused($focusedField, equals: .billAmount)
        .onChange(of: focusedField) { newFocus in
            if newFocus == .billAmount {
                if viewModel.billAmount == "0.00" {
                    viewModel.billAmount = ""
                }
            } else if newFocus != .billAmount, viewModel.billAmount.isEmpty {
                // When losing focus with an empty value, normalize to "0.00"
                viewModel.billAmount = "0.00"
            }
        }
        // ✅ Recalculate whenever billAmount changes (covers "0.00" being set later)
        .onChange(of: viewModel.billAmount) { _ in
            viewModel.calculateTip()
        }
        .padding(.top)
    }
    
    private var partyTipPickers: some View {
        HStack {
            HTPickerView(
                selectedNumber: $viewModel.party,
                upperLimit: 99,
                icon: "person.2.fill",
                iconLeading: true
            )
            .focused($focusedField, equals: .party)
            .onChange(of: viewModel.party) { _ in viewModel.calculateTip() }
            
            AnimatedNumberView(
                value: viewModel.tipAmount,
                title: UIStrings.tipAmountCap,
                hasBackground: false
            )
            
            HTPickerView(
                selectedNumber: $viewModel.tipPercent,
                upperLimit: 99,
                icon: "percent",
                iconLeading: false
            )
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
    
    // MARK: - Helpers
    private func dismissKeyboardAndCalculate() {
        guard focusedField != nil else { return }
        // If the bill text is empty while dismissing, normalize it before calculating
        if focusedField == .billAmount && viewModel.billAmount.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            viewModel.billAmount = "0.00"
        }
        viewModel.formatBillAmount()
        focusedField = nil
        // Defer so any .onChange(focusedField) mutations are applied first
        DispatchQueue.main.async {
            viewModel.calculateTip()
        }
    }
}
