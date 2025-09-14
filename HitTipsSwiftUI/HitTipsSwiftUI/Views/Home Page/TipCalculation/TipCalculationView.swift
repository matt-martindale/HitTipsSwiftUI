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
        LoaderView(isLoading: $viewModel.isLoading, message: $viewModel.loaderMessage) {
            NavigationStack {
                VStack {
                    // Bill Amount
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
                        // Party picker
                        HTPickerView(selectedNumber: $viewModel.party, upperLimit: 99, icon: "person.2.fill", iconLeading: true)
                            .focused($focusedField, equals: .party)
                            .onChange(of: viewModel.party) { _ in viewModel.calculateTip() }
                        
                        // Tip Amount
                        AnimatedNumberView(value: viewModel.tipAmount, title: UIStrings.tipAmount, hasBackground: false)
                        
                        // Percent picker
                        HTPickerView(selectedNumber: $viewModel.tipPercent, upperLimit: 99, icon: "percent", iconLeading: false)
                            .focused($focusedField, equals: .tipPercent)
                            .onChange(of: viewModel.tipPercent) { _ in viewModel.calculateTip() }
                    }
                    .padding(.horizontal)
                    
                    //Bill output view
                    BillOutputView(
                        tipPerPerson: $viewModel.tipPerPerson,
                        pricePerPerson: $viewModel.pricePerPerson,
                        totalBill: $viewModel.totalBill
                    ) { action in
                        viewModel.applyRounding(action)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Confirm tip button
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
                .alert(UIStrings.invalidAmount, isPresented: $viewModel.showInvalidAmountAlert) {
                    Button(UIStrings.ok, role: .cancel) { }
                }
                message: {
                    Text(UIStrings.enterValidAmount)
                }
            }
            .sheet(isPresented: $viewModel.showTipDetailScreen) {
                TipDetailView(tip: viewModel.tip ?? Tip.defaultTip())
            }
        }
    }
}


#Preview {
    let container = try! ModelContainer(for: Tip.self, AppSettings.self)
    TipCalculationView(context: container.mainContext)
}
