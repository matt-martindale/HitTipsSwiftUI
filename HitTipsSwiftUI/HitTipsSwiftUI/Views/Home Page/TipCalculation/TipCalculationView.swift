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
import CoreData

enum FocusedField {
    case billAmount, party, tipPercent
}

struct TipCalculationView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var viewModel: TipCalculationViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(roastSettings: RoastSettings) {
        _viewModel = StateObject(
            wrappedValue: TipCalculationViewModel(
                context: PersistenceController.shared.container.viewContext, // placeholder, replaced in body
                roastService: RoastService(apiService: APIService()),
                roastSettings: roastSettings
            )
        )
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
