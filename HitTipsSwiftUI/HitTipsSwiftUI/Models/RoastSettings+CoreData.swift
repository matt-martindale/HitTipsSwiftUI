//
//  RoastSettings+CoreData.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/24/25.
//

import Foundation

final class RoastSettings: ObservableObject {
    @Published var roastStyle: SelectedRoastStyle = .roast
    @Published var tipTier: TipTier = .decent
}

enum SelectedRoastStyle: String {
    case roast, uplifting, none
}

enum TipTier: String {
    case terrible, bad, decent, good
}
