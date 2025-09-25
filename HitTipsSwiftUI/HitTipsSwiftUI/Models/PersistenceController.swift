//
//  PersistenceController.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/24/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static let preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        // Seed sample Tip (no RoastSettings anymore)
        let sampleTip = Tip(context: viewContext)
        sampleTip.id = UUID()
        sampleTip.roast = "Preview Roast"
        sampleTip.billAmount = "42.00"
        sampleTip.totalBill = 50.0
        sampleTip.date = Date()
        sampleTip.party = 2
        sampleTip.pricePerPerson = 25.0
        sampleTip.tipPerPerson = 4.0
        sampleTip.tipAmount = 8.0
        sampleTip.tipPercentage = 20
        sampleTip.isFavorite = true

        do {
            try viewContext.save()
        } catch {
            fatalError("Failed to save preview data: \(error)")
        }

        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HitTipsModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}
