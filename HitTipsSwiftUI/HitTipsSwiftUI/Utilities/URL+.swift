//
//  URL+.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/28/25.
//

import Foundation

extension URL: Identifiable {
    public var id: String { absoluteString }
}
