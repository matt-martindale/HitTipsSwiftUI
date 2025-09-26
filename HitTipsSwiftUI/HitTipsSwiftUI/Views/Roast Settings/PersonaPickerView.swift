//
//  PersonaPickerView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/25/25.
//

import SwiftUI

struct PersonaPickerView: View {
    @State private var personas: [Persona] = Persona.all
    @State private var selectedPersona: Persona?
    @State private var showUpgradeSheet = false
    
    @EnvironmentObject var roastSettings: RoastSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Your Persona")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(personas) { persona in
                        personaCard(for: persona) // ✅ keep ForEach clean
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showUpgradeSheet) {
            // UpgradeView()
        }
    }
    
    // MARK: - Card Builder
    private func personaCard(for persona: Persona) -> some View {
        let isSelected = roastSettings.selectedPersonaID == persona.id
        
        return PersonaCardView(
            isSelected: isSelected,
            persona: persona
        )
        .onTapGesture {
            if persona.isPremium && !(persona.isFreeTrial || persona.isSeasonalUnlock) {
                showUpgradeSheet = true
            } else {
                print("HTApp: Selected \(persona.name)")
                selectedPersona = persona
                roastSettings.selectedPersonaID = persona.id
            }
        }
    }
}

#Preview {
    PersonaPickerView()
        .environmentObject(RoastSettings()) // ✅ inject environment
}

    
    // MARK: - Helpers
//    private func assignWeeklyFreeTrial() {
//        let calendar = Calendar.current
//        let weekOfYear = calendar.component(.weekOfYear, from: Date())
//        let premium = personas.filter { $0.isPremium }
//        guard !premium.isEmpty else { return }
//        
//        let index = weekOfYear % premium.count
//        let chosenID = premium[index].id
//        
//        personas = personas.map { p in
//            var copy = p
//            copy.isFreeTrial = (p.id == chosenID)
//            return copy
//        }
//    }
    
//    private func assignSeasonalUnlocks() {
//        let calendar = Calendar.current
//        let today = Date()
//        
//        personas = personas.map { p in
//            var copy = p
//            copy.isSeasonalUnlock = false
//            
//            // Halloween (Oct 25–31) → Dracula free
//            if p.name == "Dracula",
//               let halloweenStart = calendar.date(from: DateComponents(year: calendar.component(.year, from: today), month: 10, day: 25)),
//               let halloweenEnd = calendar.date(from: DateComponents(year: calendar.component(.year, from: today), month: 10, day: 31)),
//               today >= halloweenStart && today <= halloweenEnd {
//                copy.isSeasonalUnlock = true
//            }
//            
//            // Christmas (Dec 20–26) → Santa free
//            if p.name == "Santa Claus",
//               let xmasStart = calendar.date(from: DateComponents(year: calendar.component(.year, from: today), month: 12, day: 20)),
//               let xmasEnd = calendar.date(from: DateComponents(year: calendar.component(.year, from: today), month: 12, day: 26)),
//               today >= xmasStart && today <= xmasEnd {
//                copy.isSeasonalUnlock = true
//            }
//            
//            return copy
//        }
//    }
//}
