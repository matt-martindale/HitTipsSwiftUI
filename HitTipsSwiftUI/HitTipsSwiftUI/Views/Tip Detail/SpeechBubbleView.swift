//
//  SpeechBubbleView.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/28/25.
//

import SwiftUI

enum BubbleTail {
    case left, right
}

struct SpeechBubbleView: Shape {
    var tails: [BubbleTail] = [.left] // default: one tail on left
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Main bubble
        let bubbleRect = CGRect(
            x: rect.minX,
            y: rect.minY,
            width: rect.width,
            height: rect.height - 20
        )
        path.addRoundedRect(in: bubbleRect, cornerSize: CGSize(width: 16, height: 16))
        
        // Add tails
        for tail in tails {
                    switch tail {
                    case .left:
                        let baseX: CGFloat = rect.minX + 40
                        let baseY: CGFloat = rect.maxY - 20
                        
                        path.move(to: CGPoint(x: baseX, y: baseY))
                        path.addLine(to: CGPoint(x: baseX, y: rect.maxY))
                        path.addLine(to: CGPoint(x: baseX + 20, y: baseY))
                        path.closeSubpath()
                        
                    case .right:
                        let baseX: CGFloat = rect.maxX - 40
                        let baseY: CGFloat = rect.maxY - 20
                        
                        path.move(to: CGPoint(x: baseX, y: baseY))
                        path.addLine(to: CGPoint(x: baseX, y: rect.maxY))
                        path.addLine(to: CGPoint(x: baseX - 20, y: baseY))
                        path.closeSubpath()
                    }
                }
        
        return path
    }
}



#Preview {
    SpeechBubbleView()
}
