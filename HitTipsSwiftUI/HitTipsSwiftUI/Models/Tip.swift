//
//  Item.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftData
import Foundation

@Model
final class Tip {
    @Attribute(.unique) var id: UUID = UUID()
    var billAmount: String
    var totalBill: Double
    var date: Date
    var party: Int
    var pricePerPerson: Double
    var tipPerPerson: Double
    var tipAmount: Double
    var tipPercentage: Int

    init(
        billAmount: String = "",
        totalBill: Double = 0,
        date: Date = Date(),
        party: Int = 0,
        pricePerPerson: Double = 0,
        tipPerPerson: Double = 0,
        tipAmount: Double = 0,
        tipPercentage: Int = 5
    ) {
        self.billAmount = billAmount
        self.totalBill = totalBill
        self.date = date
        self.party = party
        self.pricePerPerson = pricePerPerson
        self.tipPerPerson = tipPerPerson
        self.tipAmount = tipAmount
        self.tipPercentage = tipPercentage
    }
}


