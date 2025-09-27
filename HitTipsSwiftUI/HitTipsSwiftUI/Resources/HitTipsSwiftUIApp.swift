//
//  HitTipsSwiftUIApp.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import CoreData
import Firebase
import GoogleMobileAds
import RevenueCat

@main
struct HitTipsSwiftUIApp: App {
    
    let persistenceController = PersistenceController.shared
    @StateObject private var roastSettings = RoastSettings()
    @StateObject private var subscriptionManager = SubscriptionManager()
    
    init() {
        MobileAds.shared.start()
        FirebaseApp.configure()
        Purchases.configure(withAPIKey: "appl_cFPlNfjDUUqYIMjgmzrWWAFWSWp")
        Purchases.logLevel = .debug
        UITabBar.setSolidBackground()

    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(roastSettings)
                .environmentObject(subscriptionManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
