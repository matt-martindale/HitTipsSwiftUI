//
//  UUID+.swift
//  HitTipsSwiftUI
//
//  Created by Matt Martindale on 9/28/25.
//

import Foundation
import CryptoKit

extension UUID {
    /// Generate a stable UUID from a string using SHA256
    static func fromString(_ string: String) -> UUID {
        let digest = SHA256.hash(data: Data(string.utf8))
        let bytes = Array(digest.prefix(16))  // ✅ simpler for compiler
        return UUID(uuid: (
            bytes[0], bytes[1], bytes[2], bytes[3],
            bytes[4], bytes[5], bytes[6], bytes[7],
            bytes[8], bytes[9], bytes[10], bytes[11],
            bytes[12], bytes[13], bytes[14], bytes[15]
        ))
    }
}
