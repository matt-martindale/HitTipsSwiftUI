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
    @Published var selectedPersonaID: UUID? = Persona.all.first?.id
    
    var selectedPersona: Persona? {
        guard let id = selectedPersonaID else { return nil }
        return Persona.all.first { $0.id == id }
    }
}

enum SelectedRoastStyle: String {
    case roast, hype, none
}

enum TipTier: String {
    case terrible, bad, decent, good
}
