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
    
    var body: some View {
        HStack(alignment: .center) {
            Text(title)
            
            // Fill the space with dots
            Text(Array(repeating: ". ", count: 50).joined())
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundColor(.gray)
                .allowsTightening(true)
            
            Text(value)
                .bold()
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
}

#Preview {
    ReceiptRow(title: "Tip amount", value: "$5.00")
    ReceiptRow(title: "Tip percent", value: "10%")
    ReceiptRow(title: "Bill amount", value: "$50.00")
}
