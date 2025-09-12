//
//  TipDetailView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/12/25.
//

import SwiftUI

struct TipDetailView: View {
    private var tip: Tip?
    
    init(tip: Tip?) {
        self.tip = tip
    }
    
    var body: some View {
        VStack {
            ScrollView {
                Text(tip?.roast ?? "")
                    .padding()
                    .font(.HTBody24)
            }
            Spacer()
            Group {
                ReceiptRow(title: UIStrings.billAmountLowercase, value: "$\(tip?.billAmount ?? "")")
                ReceiptRow(title: UIStrings.tipAmountLowercase, value: "$\(String(format: "%.2f", tip?.tipAmount ?? ""))")
                ReceiptRow(title: UIStrings.tipPercentLowercase, value: "\(tip?.tipPercentage ?? 0)%")
                ReceiptRow(title: UIStrings.partyLowercase, value: "\(tip?.party ?? 0)")
                ReceiptRow(title: UIStrings.tipPerPersonLowercase, value: "$\(String(format: "%.2f", tip?.tipPerPerson ?? ""))")
                ReceiptRow(title: UIStrings.pricePerPersonLowercase, value: "$\(String(format: "%.2f", tip?.pricePerPerson ?? ""))")
                ReceiptRow(title: UIStrings.totalBill, value: "$\(String(format: "%.2f", tip?.totalBill ?? ""))")
            }
        }
        .padding()
    }
}

#Preview {
    TipDetailView(tip: Tip(roast: "That tip was so small, it could fit in a fortune cookie and still leave the waiter wondering what he did wrong!", billAmount: "100.00", totalBill: 110.00, party: 2, pricePerPerson: 50, tipPerPerson: 5.25, tipAmount: 10, tipPercentage: 10))
}
