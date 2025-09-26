//
//  AppSettings+CoreData.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/24/25.
//

import Foundation
import CoreData

@objc(AppSettings)
public class AppSettings: NSManagedObject {}

extension AppSettings {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSettings> {
        return NSFetchRequest<AppSettings>(entityName: "AppSettings")
    }

    @NSManaged public var id: UUID
    @NSManaged public var lastTipPercentage: Int32
}
