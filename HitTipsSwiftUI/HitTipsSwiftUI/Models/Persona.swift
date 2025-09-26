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
    let emoji: String
    let imageName: String
    let isPremium: Bool
    var isFreeTrial: Bool = false
    var isSeasonalUnlock: Bool = false
    
    static let all: [Persona] = [
        Persona(name: "Sarcastic Comedian", emoji: "🎤", imageName: "comedian", isPremium: false),
        Persona(name: "French Waiter", emoji: "🍷", imageName: "french waiter", isPremium: false),
        Persona(name: "Diva", emoji: "👩‍🎤", imageName: "diva", isPremium: false),
        Persona(name: "Gordon Ramsay", emoji: "👨‍🍳", imageName: "gordon ramsey", isPremium: true),
        Persona(name: "Drill Sergeant", emoji: "👮", imageName: "drill sergeant", isPremium: true),
        Persona(name: "AI Robot", emoji: "🤖", imageName: "ai robot", isPremium: true),
        Persona(name: "Corporate Boss", emoji: "☠️", imageName: "corporate boss", isPremium: true),
        Persona(name: "Angsty Teen", emoji: "🙅‍♀️", imageName: "angsty teen", isPremium: true),
        Persona(name: "News Anchor", emoji: "👩‍💼", imageName: "news anchor", isPremium: true),
        Persona(name: "Shakespearean Bard", emoji: "🎭", imageName: "shakespearean bard", isPremium: true)
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
