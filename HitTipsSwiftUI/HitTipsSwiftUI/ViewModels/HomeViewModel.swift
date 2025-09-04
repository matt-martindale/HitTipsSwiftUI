//
//  HomeViewModel.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/4/25.
//

import Foundation

class HomeViewModel {
    var navigationTitle: String = "HitTips"
    
    init() {
        setNavigationTitle()
    }
    
    private func setNavigationTitle() {
        self.navigationTitle = "HitTips"
    }
}
