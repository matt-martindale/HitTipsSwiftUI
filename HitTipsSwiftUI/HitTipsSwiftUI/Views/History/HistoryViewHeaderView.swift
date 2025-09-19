//
//  HistoryViewHeaderView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/14/25.
//

import SwiftUI

struct HistoryViewHeaderView: View {
    var body: some View {
        HStack {
            Text(UIStrings.date)
                .font(.HTBody16)
                .frame(width: 100, alignment: .leading)
            Spacer()
            Text(UIStrings.bill)
                .font(.HTBody16)
                .offset(x: -20)
            Spacer()
            Text(UIStrings.percent)
                .font(.HTBody16)
                .offset(x: -40)
        }
    }
}

#Preview {
    HistoryViewHeaderView()
}
