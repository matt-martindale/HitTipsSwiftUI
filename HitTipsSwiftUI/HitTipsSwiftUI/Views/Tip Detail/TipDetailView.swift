//
//  TipDetailView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/12/25.
//

import SwiftUI

struct TipDetailView: View {
    private var tip: Tip
    
    init(tip: Tip) {
        self.tip = tip
    }
    
    var body: some View {
        Text(String(format: "%.2f", tip.totalBill))
    }
}

#Preview {
    TipDetailView(tip: Tip(billAmount: "100", totalBill: 110.00, party: 2, pricePerPerson: 50, tipPerPerson: 5, tipAmount: 10, tipPercentage: 10))
}
