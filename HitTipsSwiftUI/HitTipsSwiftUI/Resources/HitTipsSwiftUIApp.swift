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

@main
struct HitTipsSwiftUIApp: App {
    
    let persistenceController = PersistenceController.shared
    @StateObject private var roastSettings = RoastSettings()
    
    init() {
        MobileAds.shared.start()
        FirebaseApp.configure()
        UITabBar.setSolidBackground()

    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(roastSettings)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
