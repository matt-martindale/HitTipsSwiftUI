//
//  HitTipsSwiftUIApp.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData
import Firebase

// Top-level shared ModelContainer
var sharedModelContainer: ModelContainer = {
    do {
        return try ModelContainer(for: Tip.self)
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()

@main
struct HitTipsSwiftUIApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .modelContainer(sharedModelContainer)
        }
    }
}
