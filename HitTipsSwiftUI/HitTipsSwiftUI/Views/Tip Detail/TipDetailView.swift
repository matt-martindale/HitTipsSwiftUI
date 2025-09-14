//
//  TipDetailView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/12/25.
//

import SwiftUI

struct TipDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable private var tip: Tip
        
        init(tip: Tip) {
            self._tip = Bindable(wrappedValue: tip)
        }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                        let width = geo.size.width
                Image("HitTipsLogoTransparent")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width)
                    .rotationEffect(.degrees(15))
                    .opacity(0.05)
                    }
            VStack {
                HStack() {
                    Spacer()
                    Button {
                        favoriteTapped()
                    } label: {
                        Image(systemName: tip.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(.htRed)
                            .font(.HTBody24)
                    }
                }
                .frame(height: 20)
                ScrollView {
                    Text(tip.roast)
                        .padding()
                        .font(.HTBody24)
                }
                Spacer()
                Group {
                    ReceiptRow(title: UIStrings.billAmountLowercase, value: "$\(tip.billAmount)")
                    ReceiptRow(title: UIStrings.tipAmountLowercase, value: "$\(String(format: "%.2f", tip.tipAmount))")
                    ReceiptRow(title: UIStrings.tipPercentLowercase, value: "\(tip.tipPercentage)%")
                    ReceiptRow(title: UIStrings.partyLowercase, value: "\(tip.party)")
                    ReceiptRow(title: UIStrings.tipPerPersonLowercase, value: "$\(String(format: "%.2f", tip.tipPerPerson))")
                    ReceiptRow(title: UIStrings.pricePerPersonLowercase, value: "$\(String(format: "%.2f", tip.pricePerPerson))")
                    ReceiptRow(title: UIStrings.totalBill, value: "$\(String(format: "%.2f", tip.totalBill))", isHighlight: true)
                }
            }
            .padding()
        }
    }
    
    private func favoriteTapped() {
        tip.isFavorite.toggle()
        
        do {
                try modelContext.save() // Persist changes
                print("Tip favorite state saved!")
            } catch {
                print("Failed to save tip: \(error.localizedDescription)")
            }
    }
}

#Preview {
    TipDetailView(tip: Tip(roast: "That tip was so small, it could fit in a fortune cookie and still leave the waiter wondering what he did wrong!", billAmount: "100.00", totalBill: 110.00, party: 2, pricePerPerson: 50, tipPerPerson: 5.25, tipAmount: 10, tipPercentage: 10))
}
