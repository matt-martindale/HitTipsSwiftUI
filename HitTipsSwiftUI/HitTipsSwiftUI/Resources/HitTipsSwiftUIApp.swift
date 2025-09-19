//
//  HitTipsSwiftUIApp.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData
import Firebase
import GoogleMobileAds

var sharedModelContainer: ModelContainer = {
    do {
        return try ModelContainer(for: Tip.self, AppSettings.self) // ✅ modern API
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()


@main
struct HitTipsSwiftUIApp: App {
    
    @StateObject private var fireStoreManager = FirestoreManager()
    
    init() {
        MobileAds.shared.start()
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(fireStoreManager)
                .modelContainer(sharedModelContainer)
        }
    }
}
