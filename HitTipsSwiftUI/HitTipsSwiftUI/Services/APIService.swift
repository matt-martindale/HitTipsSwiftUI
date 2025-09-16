//
//  APIService.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/5/25.
//

import Foundation
import FirebaseFunctions

class APIService: ObservableObject {
    
    func callFirebaseApi(completion: @escaping (String?) -> Void) {
        let functions = Functions.functions()
        functions.useEmulator(withHost: "127.0.0.1", port: 5001)
        
        functions.httpsCallable("callExternalApi").call(["prompt": "roast a terrible tip I left at a restaurant"]) { result, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let response = result?.data as? String {
                completion(response)
            }
        }
    }
    
    //    @Published var result: String = ""
    //
    //    private let baseURL = "http://localhost:5001/hittips-8c1eb/us-central1"
    //    func sendData() {
    //        guard let url = URL(string: "\(baseURL)/callExternalApi") else { return }
    //
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    //
    //        let body: [String: Any] = [
    //            "model": "gpt-4o-mini",
    //            "messages":
    //                [
    //                    [
    //                        "role": "user", "content": [[
    //                            "type": "text",
    //                            "text": "tell me how good looking I am"
    //                        ]]
    //                    ]
    //                ]
    //        ]
    //        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    //
    //        URLSession.shared.dataTask(with: request) { data, _, error in
    //            if let error = error {
    //                print("Error:", error.localizedDescription)
    //                return
    //            }
    //
    //            if let data = data,
    //               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
    //                DispatchQueue.main.async {
    //                    self.result = (json["id"] as AnyObject).description ?? "No response id"
    //                }
    //            }
    //        }.resume()
    //    }
    
}
