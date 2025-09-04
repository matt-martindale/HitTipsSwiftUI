//
//  HitTipsSwiftUIApp.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI
import SwiftData

@main
struct HitTipsSwiftUIApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Tip.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SplashScreen()
        }
        .modelContainer(sharedModelContainer)
    }
}
