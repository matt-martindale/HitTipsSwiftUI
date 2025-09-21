//
//  TipCalculationView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

//
//  TipCalculationView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData

enum FocusedField {
    case billAmount, party, tipPercent
}

struct TipCalculationView: View {
    @StateObject private var viewModel: TipCalculationViewModel
    @FocusState private var focusedField: FocusedField?

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
                        .frame(height: 40)
                    confirmButton
                    Spacer()
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
            // Tip Detail Sheet controlled by VM
            .sheet(isPresented: $viewModel.showTipDetailScreen) {
                if let tip = viewModel.tip {
                    TipDetailView(tip: tip, entryPoint: .sheet)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
}
