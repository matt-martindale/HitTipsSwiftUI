//
//  Persona.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/25/25.
//

import Foundation

struct Persona: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let emoji: String
    let imageName: String
    let isPremium: Bool
    var isFreeTrial: Bool = false
    var isSeasonalUnlock: Bool = false
    
    static let all: [Persona] = [
        Persona(name: "Sarcastic Comedian", description: "Roasts you with witty one-liners", emoji: "🎤", imageName: "comedian", isPremium: false),
        Persona(name: "French Waiter", description: "Judges your tip with a snobby accent", emoji: "🍷", imageName: "french waiter", isPremium: false),
        Persona(name: "Fabulous Diva", description: "Throws shade with dramatic flair", emoji: "👩‍🎤", imageName: "diva", isPremium: false),
        Persona(name: "Angsty Teen", description: "Rolls eyes and mocks everything you do", emoji: "🙅‍♀️", imageName: "angsty teen", isPremium: false),
        Persona(name: "Gordon Ramsay", description: "Yells at you like a famous chef", emoji: "👨‍🍳", imageName: "gordon ramsey", isPremium: false),
        Persona(name: "Shakespearean Bard", description: "Insults you in dramatic Old English verse", emoji: "🎭", imageName: "shakespearean bard", isPremium: false),
        Persona(name: "Drill Sergeant", description: "Barks orders and insults like in boot camp", emoji: "👮", imageName: "drill sergeant", isPremium: false),
        Persona(name: "AI Robot", description: "Delivers cold, mechanical burns", emoji: "🤖", imageName: "ai robot", isPremium: false),
        Persona(name: "Corporate Boss", description: "Disappoints you, like a boss", emoji: "☠️", imageName: "corporate boss", isPremium: false),
        Persona(name: "News Anchor", description: "Reports your failure with breaking news", emoji: "👩‍💼", imageName: "news anchor", isPremium: false)
        ]
    
    /* Future Personas:
     Royal Aristocrat (pompous, old-money put-downs) - Free
     Lord NoYen (super dramatic anime monologue character) - Premium
     Evil Villian (dramatic, world-domination energy) - Premium
     Proverbial Mentor (calm, pseudo-philosophical roasts) - Premium
     
     Seasonal Personas:
     Santa Clause
     Elf
     Frankenstein
     Vampire
     Leprachaun
     Founding Father
    */
}

extension Persona: Equatable {
    static func == (lhs: Persona, rhs: Persona) -> Bool {
        lhs.id == rhs.id
    }
}
