//
//  FirestoreManager.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/19/25.
//

import Foundation
import Firebase

class FirestoreManager: ObservableObject {
    let firestoreAppSettings = "sqvb8vSKZBSRbk6Fw2ba"
    
    init() {
        fetchAppSettingsAndSaveToUserDefaults()
    }
    
    func fetchAppSettingsAndSaveToUserDefaults() {
        let db = Firestore.firestore()
        
        db.collection("appSettings").document(firestoreAppSettings).getDocument { document, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            if let document = document, document.exists {
                guard let data = document.data() else {
                    print("Error encoding Data")
                    return
                }
                
                // map app settings and provide default value
                let aiModel = data["aiModel"] as? String ?? "gpt-4o-mini"
                let adFrequency = data["adFrequency"] as? Int ?? 2
                
                print("AI model:\(aiModel), Ad frequency:\(adFrequency)")
                
                // Save to user defaults
                UserDefaultsManager.shared.updateAiModelToUserDefaults(aiModel)
                UserDefaultsManager.shared.updateAdFrequencyToUserDefaults(adFrequency)
            }
        }
    }
    
}
