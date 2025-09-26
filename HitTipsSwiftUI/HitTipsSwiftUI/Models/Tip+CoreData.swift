//
//  Tip+CoreData.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/24/25.
//

import Foundation
import CoreData

@objc(Tip)
public class Tip: NSManagedObject {}

extension Tip: Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tip> {
        return NSFetchRequest<Tip>(entityName: "Tip")
    }

    @NSManaged public var id: UUID
    @NSManaged public var roast: String
    @NSManaged public var billAmount: String
    @NSManaged public var totalBill: Double
    @NSManaged public var date: Date
    @NSManaged public var party: Int32
    @NSManaged public var pricePerPerson: Double
    @NSManaged public var tipPerPerson: Double
    @NSManaged public var tipAmount: Double
    @NSManaged public var tipPercentage: Int32
    @NSManaged public var isFavorite: Bool
    @NSManaged public var roastStyle: String
    @NSManaged public var tipTier: String
    @NSManaged public var personaID: UUID?

}

extension Tip {
    var safeDate: Date {
        if self.managedObjectContext == nil { return Date() }
        return self.date
    }
}

extension Tip {
    var persona: Persona? {
        guard let pid = personaID else { return nil }
        return Persona.all.first(where: { $0.id == pid })
    }
}
