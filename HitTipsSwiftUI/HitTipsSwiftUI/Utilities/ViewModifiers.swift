//
//  ViewModifiers.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/9/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
