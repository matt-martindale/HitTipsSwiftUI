//
//  RoastSettings.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/23/25.
//

import SwiftUI

enum SelectedRoastStyle: String {
    case roast, hype, none
}

final class RoastSettings: ObservableObject {
    @Published var roastStyle: SelectedRoastStyle = .roast
}
