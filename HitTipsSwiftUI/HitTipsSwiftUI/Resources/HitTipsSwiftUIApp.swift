//
//  HitTipsSwiftUIApp.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData

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
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .modelContainer(sharedModelContainer)
        }
    }
}
