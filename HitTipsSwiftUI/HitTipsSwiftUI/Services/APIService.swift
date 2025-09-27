//
//  APIService.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/5/25.
//

import Foundation
import FirebaseFunctions
import FirebaseAuth

class APIService: ObservableObject {
    
    func callFirebaseApi(prompt: String, completion: @escaping (String?) -> Void) {
        let model = UserDefaultsManager.shared.aiModel
        let prompt = String(format: "roast a %@ tip I left at a restaurant", prompt)
        
        if Auth.auth().currentUser == nil {
                Auth.auth().signInAnonymously { result, error in
                    if let error = error {
                        print("HTApp: Anonymous sign-in failed:", error)
                        return
                    }
                    print("HTApp: Signed in anonymously")
                    // Call the function after signing in
                    self.callApiAfterSignIn(prompt: prompt, model: model) { response in
                        completion(response)
                    }
                }
            } else {
                // Already signed in
                callApiAfterSignIn(prompt: prompt, model: model) { response in
                    completion(response)
                }
            }
    }
    
    private func callApiAfterSignIn(prompt: String, model: String, completion: @escaping (String?) -> Void) {
#if DEBUG
        let functionName = "callExternalApiDev"   // dev version
        let functions = Functions.functions(region: "us-central1")
//        functions.useEmulator(withHost: "127.0.0.1", port: 5001)
#else
        let functionName = "callExternalApi"      // prod version
        let functions = Functions.functions(region: "us-central1")
#endif
        
        let data: [String: Any] = [
            "prompt": prompt,
            "model": model
        ]
        
        functions.httpsCallable(functionName).call(data) { result, error in
            if let error = error {
                print("HTApp: Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let response = result?.data as? String {
                completion(response)
            }
        }
    }
    
}
