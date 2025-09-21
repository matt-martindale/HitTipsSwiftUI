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
}
