//
//  Tip+Preview.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/24/25.
//

import CoreData

extension Tip {
    static var preview: Tip {
        let context = PersistenceController.preview.container.viewContext

        // If we already seeded in PersistenceController, reuse it
        let request = NSFetchRequest<Tip>(entityName: "Tip")
        if let tips = try? context.fetch(request), let first = tips.first {
            return first
        }

        // Otherwise, make a fallback sample
        let tip = Tip(context: context)
        tip.id = UUID()
        tip.roast = "That tip was so small, it could fit in a fortune cookie and still leave the waiter wondering what he did wrong!"
        tip.billAmount = "100.00"
        tip.totalBill = 110.00
        tip.date = .now
        tip.party = 2
        tip.pricePerPerson = 50
        tip.tipPerPerson = 5.25
        tip.tipAmount = 10
        tip.tipPercentage = 10
        tip.isFavorite = false
        return tip
    }
}
