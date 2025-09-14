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
            Spacer()
            Text("$" + String(format: "%.2f", tip.totalBill))
            Spacer()
            Text("\(tip.tipPercentage)%")
            Image(systemName: tip.isFavorite ? "heart.fill" : "")
        }
    }
}

#Preview {
    HistoryListItemView(tip: Tip(roast: "That tip was so small, it could fit in a fortune cookie and still leave the waiter wondering what he did wrong!", billAmount: "100.00", totalBill: 110.00, party: 2, pricePerPerson: 50, tipPerPerson: 5.25, tipAmount: 10, tipPercentage: 10))
}
