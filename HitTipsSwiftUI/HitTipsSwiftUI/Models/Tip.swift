//
//  Item.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import Foundation
import SwiftData

@Model
final class Tip {
    var id: UUID
    var billAmount: Double
    var totalBill: Double
    var date: Date
    var party: Int
    var pricePerPerson: Double
    var tipPerPerson: Double
    var tipAmount: Double
    var tipPercentage: Int
//    var tipTier: TipTier
    
    init(billAmount: Double,
         totalBill: Double,
         date: Date,
         party: Int,
         pricePerPerson: Double,
         tipPerPerson: Double,
         tipAmount: Double,
         tipPercentage: Int
//         tipTier: TipTier
    ) {
        self.id = UUID()
        self.billAmount = billAmount
        self.totalBill = totalBill
        self.date = date
        self.party = party
        self.pricePerPerson = pricePerPerson
        self.tipPerPerson = tipPerPerson
        self.tipAmount = tipAmount
        self.tipPercentage = tipPercentage
//        self.tipTier = tipTier
    }
}
