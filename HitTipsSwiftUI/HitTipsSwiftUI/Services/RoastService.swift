//
//  RoastService.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/23/25.
//

import Foundation

protocol RoastProviding {
    func fetchRoast(settings: RoastSettings, completion: @escaping (String?) -> Void)
}

final class RoastService: RoastProviding {
    
    private let apiService: APIService
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    func fetchRoast(settings: RoastSettings, completion: @escaping (String?) -> Void) {
        let prompt = """
        Give me a \(settings.roastStyle) style roast.
        Tip tier: \(settings.tipTier).
        """
        
        print("HTApp: prompt - \(prompt)")
        apiService.callFirebaseApi(prompt: prompt) { roast in
            completion(roast)
        }
    }
}
