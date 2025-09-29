//
//  UIStrings.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/9/25.
//

import Foundation

struct UIStrings {
    static let hitTips = "HitTips"
    
    // Loader view
    static let loading = "Loading..."
    private static let roastTextArray = [
        "Preheating the oven for your roast…",
        "Sharpening the chef’s knife…",
        "Marinating your humiliation…",
        "Seasoning this roast just right…",
        "Letting the burn simmer…",
        "Cooking up some premium sass…",
        "Checking if it’s medium-rare or well-done…",
        "Roast in progress… please hold your ego…",
        
        "Crunching numbers and egos…",
        "Downloading insults from the cloud…",
        "Applying advanced sarcasm algorithms…",
        "Waiting for neurons to finish laughing…",
        "Debugging your life choices…",
        "Optimizing burn efficiency…",
        
        "Sorry, this might sting a little…",
        "Finding the line between mean and funny…",
        "Making sure we can still be friends after this…",
        "Checking if your ego has insurance…",
        "Hold on, this roast is extra crispy…",
        
        "Roast loading…",
        "Warming up burns…",
        "Igniting sarcasm…",
        "Fueling the flame thrower…",
        "Serving fresh humiliation…",
        "Your roast will be ready in a moment…"
    ]

    static var randomFetchingRoastArray: String {
        return roastTextArray.randomElement() ?? "Cooking up a roast..."
    }
    static let processingResponse = "Processing response..."
    
    // Home page
    static let billAmountCap = "BILL AMOUNT"
    static let tipAmountCap = "TIP AMOUNT"
    static let tipPercentCap = "TIP PERCENT"
    static let tipPerPersonCap = "TIP/PERSON"
    static let pricePerPersonCap = "PRICE/PERSON"
    static let totalBillCap = "TOTAL BILL"
    static let confirmTip = "Confirm tip"
    static let done = "Done"
    static let ok = "OK"
    static let invalidAmount = "Invalid Amount"
    static let enterValidAmount = "Please enter a valid bill amount."
    static let ssww = "Sorry, something went wrong."
    static let pleaseTryAgain = "Please try again."
    
    // Roast settings
    static let roastSettings = "🔥 Roast Settings 🔥"
    static let roastMe = "🔥 Roast Me"
    static let hypeMe = "🌟 Hype Me"
    static let roastMeDescription = "Get a playful burn with a light-hearted insult."
    static let hypeMeDescription = "Ridiculously flattering hype to boost your ego."
    static let choosePersona = "Choose Your Persona:"
    
    // Tip detail
    static let billAmountLowercase = "Bill Amount"
    static let tipAmountLowercase = "Tip Amount"
    static let tipPercentLowercase = "Tip %"
    static let partyLowercase = "Party"
    static let tipPerPersonLowercase = "Tip/Person"
    static let pricePerPersonLowercase = "Price/Person"
    
    // History
    static let history = "History"
    static let noSavedTips = "No saved tips"
    static let deleteAllTips = "Are you sure you want to delete all tips?"
    static let date = "Date"
    static let bill = "Bill"
    static let percent = "Tip %"
    
    // Paywall
    static let unlockPremium = "Unlock Premium"
    static let paywallSubtitle = "3-Day Free Trial • Cancel Anytime"
    static let premiumPerk1 = "All Premium Personas"
    static let premiumPerk2 = "Ad-Free Experience"
    static let premiumPerk3 = "Smarter AI Model"
    static let premiumPerk4 = "Seasonal Unlocks (Santa, Dracula & more)"
    static let premiumPerk5 = "Priority Access to New Features"
    static let paywallCTA = "Start Free Trial"
    static let paywallLoading = "Loading plans…"
    static let restorePurchases = "Restore Purchases"
    static let termsOfUse = "Terms of Use"
    static let termsOfUseURL = "https://matt-martindale.github.io/terms.html"
    static let privacyPolicy = "Privacy Policy"
    static let privacyPolicyURL = "https://matt-martindale.github.io/privacy.html"
    static let footerTerms = "Cancel anytime. Subscription renews automatically at %@/month unless canceled at least 24 hours before the end of trial."
}
