//
//  BillOutputView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/9/25.
//

import SwiftUI

struct BillOutputView: View {
    @Binding var tipPerPerson: String
    @Binding var pricePerPerson: String
    @Binding var totalBill: String
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    HTTextField(title: UIStrings.tipPerPerson, value: $tipPerPerson, isDisabled: true, hasBackground: true)
                    HTTextField(title: UIStrings.pricerPerPerson, value: $pricePerPerson, isDisabled: true, hasBackground: true)
                }
                HStack {
                    HTTextField(title: UIStrings.totalBill, value: $totalBill, isDisabled: true, hasBackground: true)
                    VStack(spacing: 4) {
                        Button(action: {
                            print("Round up")
                        }) {
                            Image(systemName: "arrow.up.square")
                                .font(.HTBody30)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color(.label), .htGreen)
                        }
                        Button(action: {
                            print("Round down")
                        }) {
                            Image(systemName: "arrow.down.square")
                                .font(.HTBody30)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color(.label), .htRed)
                        }
                    }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 8)
            .background(.htGray2)
            .appCornerRadius()
        }
    }
}

#Preview {
    BillOutputView(tipPerPerson: .constant("12.34"), pricePerPerson: .constant("98.76"), totalBill: .constant("123.45"))
}
