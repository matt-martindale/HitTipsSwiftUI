//
//  TabBar+.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/30/25.
//

import UIKit

extension UITabBar {
    static var height: CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController?.tabBarController?.tabBar.frame.height ?? 49
    }
}
