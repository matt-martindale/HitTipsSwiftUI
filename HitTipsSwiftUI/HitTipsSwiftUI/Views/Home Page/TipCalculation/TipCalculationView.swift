//
//  TipCalculationView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData

enum FocusedField {
    case billAmount
    case party
    case tipPercent
}

struct TipCalculationView: View {
    
    @StateObject private var viewModel: TipCalculationViewModel
    @FocusState private var focusedField: FocusedField?
    
    init(context: ModelContext) {
        // Pass in context to ViewModel
        _viewModel = StateObject(wrappedValue: TipCalculationViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HTTextField(title: UIStrings.billAmount, value: $viewModel.billAmount, keyboardType: .decimalPad)
                    .focused($focusedField, equals: .billAmount)
                    .onChange(of: focusedField) { newFocus in
                        if newFocus == .billAmount && viewModel.billAmount == "0.00" {
                            viewModel.billAmount = ""
                        } else if newFocus != .billAmount && viewModel.billAmount.isEmpty {
                            viewModel.billAmount = "0.00"
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                
                HStack {
                    HTPickerView(selectedNumber: $viewModel.party, upperLimit: 99, icon: "person.2.fill", iconLeading: true, initialValue: 1)
                        .focused($focusedField, equals: .party)
                        .onChange(of: viewModel.party) { _ in viewModel.calculateTip() }
                    
                    AnimatedNumberView(value: viewModel.tipAmount, title: UIStrings.tipAmount, hasBackground: false)
                    
                    HTPickerView(selectedNumber: $viewModel.tipPercent, upperLimit: 99, icon: "percent", iconLeading: false, initialValue: 15)
                        .focused($focusedField, equals: .tipPercent)
                        .onChange(of: viewModel.tipPercent) { _ in viewModel.calculateTip() }
                }
                .padding(.horizontal)
                
                BillOutputView(
                    tipPerPerson: $viewModel.tipPerPerson,
                    pricePerPerson: $viewModel.pricePerPerson,
                    totalBill: $viewModel.totalBill
                ) { action in
                    viewModel.applyRounding(action)
                }
                .padding(.horizontal)
                
                Spacer()
                
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
            .appCornerRadius()
            .toolbar {
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
            .alert("Invalid Amount", isPresented: $viewModel.showInvalidAmountAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please enter a valid bill amount.")
            }
        }
    }
}


#Preview {
    let container = try! ModelContainer(for: Tip.self)
    TipCalculationView(context: container.mainContext)
}
