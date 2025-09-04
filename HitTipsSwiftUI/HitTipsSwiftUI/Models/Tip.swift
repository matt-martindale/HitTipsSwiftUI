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
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
