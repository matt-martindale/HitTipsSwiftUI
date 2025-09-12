//
//  AppSettings.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/12/25.
//

import SwiftData
import Foundation

@Model
final class AppSettings {
    @Attribute(.unique) var id: UUID = UUID()
    var lastTipPercentage: Int = 15  // default
    
    init(lastTipPercentage: Int = 15) {
        self.lastTipPercentage = lastTipPercentage
    }
}
