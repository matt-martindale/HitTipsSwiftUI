//
//  ViewModifiers.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/9/25.
//

import SwiftUI

struct TextFieldBorder: ViewModifier {
    var color: Color = .gray       // border color
    var lineWidth: CGFloat = 2     // border thickness
    var cornerRadius: CGFloat = 8  // border corner radius
    
    func body(content: Content) -> some View {
        content
            .padding(10) // inner padding for text
            .background(Color(.systemBackground)) // adaptive background
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: lineWidth)
            )
    }
}
