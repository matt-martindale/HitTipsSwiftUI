//
//  ReceiptRow.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/12/25.
//

import SwiftUI

struct ReceiptRow: View {
    let title: String
    let value: String
    let isHighlight: Bool
    
    init(title: String, value: String, isHighlight: Bool = false) {
        self.title = title
        self.value = value
        self.isHighlight = isHighlight
    }
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(isHighlight ? Color.primary : .gray)
                .font(isHighlight ? .HTBody20 : .HTBody16)

            // Use flexible spacer for dots
            Dots()
                .foregroundColor(.gray)

            Text(value)
                .font(.system(.body, design: .monospaced))
                .bold(isHighlight)
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
}

struct Dots: View {
    var body: some View {
        GeometryReader { geo in
            let dotCount = Int(geo.size.width / 8) // same divisor for all rows
            Text(String(repeating: ".", count: max(dotCount, 0)))
                .font(.system(.body, design: .monospaced)) // <-- monospaced keeps vertical alignment
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
        .frame(height: 20) // fix line height so all rows align
    }
}


#Preview {
    ReceiptRow(title: "Tip amount", value: "$5.00")
    ReceiptRow(title: "Tip percent", value: "10%")
    ReceiptRow(title: "Bill amount", value: "$50.00")
    ReceiptRow(title: "Total Bill", value: "$100.00", isHighlight: true)
}
