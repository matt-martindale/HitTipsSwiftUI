//
//  SplashScreenView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 1.0
    @State private var logoOpacity: Double = 1.0
    
    var body: some View {
        ZStack {
            // Main content (appears after splash fades)
            ContentView()
                .opacity(isActive ? 1 : 0)
            
            // Splash overlay
            if !isActive {
                Color(.systemBackground).ignoresSafeArea()
                
                VStack {
                    Image("HitTipsLogoTransparent") // Add PNG to Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                }
                .onAppear {
                    Task {
                        // Initial animation (scale in)
//                        withAnimation(.easeInOut(duration: 1.0)) {
//                            logoScale = 1.0
//                        }
                        
                        // Simulate loading work (replace with real data fetch)
                        try? await Task.sleep(nanoseconds: 3_000_000_000)
                        
                        // Fade out smoothly
                        withAnimation(.easeInOut(duration: 0.5)) {
                            logoOpacity = 0.0
                            logoScale = 0.8
                        }
                        
                        // Delay before removing splash view
                        try? await Task.sleep(nanoseconds: 800_000_000)
                        
                        isActive = true
                    }
                }
            }
        }
    }
}

