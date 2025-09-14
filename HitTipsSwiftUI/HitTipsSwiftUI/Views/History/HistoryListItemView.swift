//
//  HistoryListItemView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/14/25.
//

import SwiftUI

struct HistoryListItemView: View {
    private var tip: Tip
    
    init(tip: Tip) {
        self.tip = tip
    }
    
    var body: some View {
        HStack {
            Text(tip.date.toString())
                .font(.HTBody16)
            Text("$" + String(format: "%.2f", tip.totalBill))
                .font(.HTBody16)
            Spacer()
            Text("\(tip.tipPercentage)%")
                .font(.HTBody16)
            Image(systemName: "heart.fill")
                .foregroundStyle(.htRed)
                .font(.HTBody16)
                .frame(width: 30)
                .opacity(tip.isFavorite ? 1 : 0)
        }
    }
}

#Preview {
    HistoryListItemView(tip: Tip(roast: "That tip was so small, it could fit in a fortune cookie and still leave the waiter wondering what he did wrong!", billAmount: "100.00", totalBill: 110.00, party: 2, pricePerPerson: 50, tipPerPerson: 5.25, tipAmount: 10, tipPercentage: 10, isFavorite: true))
    HistoryListItemView(tip: Tip(roast: "That tip was so small, it could fit in a fortune cookie and still leave the waiter wondering what he did wrong!", billAmount: "100.00", totalBill: 110.00, party: 2, pricePerPerson: 50, tipPerPerson: 5.25, tipAmount: 10, tipPercentage: 10, isFavorite: false))
}
