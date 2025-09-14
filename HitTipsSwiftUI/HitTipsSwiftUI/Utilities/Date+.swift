//
//  Date+.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/14/25.
//

import Foundation

extension Date {
    func toString(format: String = "MMM dd, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
