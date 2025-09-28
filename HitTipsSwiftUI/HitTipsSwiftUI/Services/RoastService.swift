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
        let userPrompt = """
        Respond in 1–2 sentences.
        """
        
        let parameters: [String: Any] = [
            "prompt": userPrompt,
            "persona": settings.selectedPersona?.name ?? "Sarcastic Comedian",
            "roastType": settings.roastStyle.rawValue,
            "tipTier": settings.tipTier.rawValue
        ]
        
        print("HTApp: parameters - \(parameters)")
        
        apiService.callFirebaseApi(parameters: parameters) { roast in
            completion(roast)
        }
    }
}
