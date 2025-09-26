//
//  HistoryListItemView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/14/25.
//

import SwiftUI

struct HistoryListItemView: View {
    @ObservedObject var tip: Tip
    
    var body: some View {
        HStack {
            Text(tip.safeDate.toString())
                .font(.HTBody16)
            Spacer()
            Text("$" + String(format: "%.2f", tip.totalBill))
                .font(.HTBody16)
            Spacer()
            Text("\(tip.tipPercentage)%")
                .font(.HTBody16)
            Image(systemName: "heart.fill")
                .foregroundStyle(.htRed)
                .font(.HTBody14)
                .frame(width: 20)
                .opacity(tip.isFavorite ? 1 : 0)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sampleTip = Tip(context: context)
    sampleTip.id = UUID()
    sampleTip.date = Date()
    sampleTip.totalBill = 42.0
    sampleTip.tipPercentage = 20
    sampleTip.isFavorite = true
    
    return HistoryListItemView(tip: sampleTip)
        .environment(\.managedObjectContext, context)
}
