//
//  Extensions.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/02/2022.
//

import Foundation
import SwiftUI
import AVFoundation

extension String {
    public func getArtworkURLForSize(_ size: Int) -> String {
        self.replacingOccurrences(of: "%w", with: String(size * 2))
            .replacingOccurrences(of: "%h", with: String(size * 2))
            .replacingOccurrences(of: "{w}", with: String(size * 2))
            .replacingOccurrences(of: "{h}", with: String(size * 2))
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
}

extension AVPlayer {
    public var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension Array where Element == Track {
    func removingDuplicates() -> [Track] {
        var addedDict = [String: Track]()
        
        return filter {
            addedDict.updateValue($0, forKey: $0.sourceID) == nil
        }
    }
}

extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
    
    public func split(into parts: Int) -> [[Element]]  {
        let subArrSize = self.count / parts + 1
        return stride(from: 0, to: count, by: subArrSize).map {
            Array(self[$0 ..< Swift.min($0 + subArrSize, count)])
        }
    }

}

struct CustomJSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: CustomJSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}

func makeURLSafe(queryName: String, value: String) -> String? {
    var urlComponents = URLComponents()
    urlComponents.queryItems = [
        URLQueryItem(name: queryName, value: value)
    ]
    return urlComponents.url?.query?.description
}

extension String {
    func makeURLSafe() -> String {
        let unreserved = ":&=_?./,-"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        
        return self.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)!
    }
}

public struct ErrorMessage: Error {
    public var title: String
    public var message: String
    
    public init(_ title: String, _ message: String) {
        self.title = title
        self.message = message
    }
}

extension String {
    func convertJSONStringToModel<T: Decodable>(to: T.Type) -> T? {
        do {
            let escapedString = self.replacingOccurrences(of: "\n", with: "")
            let data = Data(escapedString.utf8)
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            print("Error decoding: \(error)")
            return nil
        }
    }
}

extension Array where Element: Equatable {
    
    public func doesNotContain(_ element: Self.Element) -> Bool {
        !(self.contains(element))
    }
    
}
