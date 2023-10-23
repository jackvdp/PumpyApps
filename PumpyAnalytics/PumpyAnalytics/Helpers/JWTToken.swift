//
//  JWTToken.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 22/10/2023.
//

import Foundation

struct JWTToken: Codable {
    let amToken: String
}

struct JWTDecoder {
    
    static func isTokenValid(_ jwt: String, targetDate: Date = Date()) -> Bool {
        let parts = jwt.components(separatedBy: ".")
        if parts.count != 3 { return false }

        let payloadData = Data(base64Encoded: parts[1], options: .ignoreUnknownCharacters)
        guard let data = payloadData,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else {
            return false
        }

        let expirationDate = Date(timeIntervalSince1970: exp)
        return targetDate < expirationDate
    }

}
