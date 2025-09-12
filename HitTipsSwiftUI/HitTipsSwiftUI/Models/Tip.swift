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
    var roast: String
    var billAmount: String
    var totalBill: Double
    var date: Date
    var party: Int
    var pricePerPerson: Double
    var tipPerPerson: Double
    var tipAmount: Double
    var tipPercentage: Int
    var isFavorite: Bool

    init(
        roast: String,
        billAmount: String,
        totalBill: Double,
        date: Date = Date(),
        party: Int,
        pricePerPerson: Double,
        tipPerPerson: Double,
        tipAmount: Double,
        tipPercentage: Int,
        isFavorite: Bool = false
    ) {
        self.roast = roast
        self.billAmount = billAmount
        self.totalBill = totalBill
        self.date = date
        self.party = party
        self.pricePerPerson = pricePerPerson
        self.tipPerPerson = tipPerPerson
        self.tipAmount = tipAmount
        self.tipPercentage = tipPercentage
        self.isFavorite = isFavorite
    }
}


