//
//  UserDefaultsStored.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 30/07/2023.
//

import Foundation

/// Stores wrapped value in UserDefaults.
///
/// ```
/// @UserDefaultsStorage<String>(key: "Key", defaultValue: "BackUp")
/// var storedString
/// print(storedString) // "BackUp"
/// storedString = "NewString"
/// print(storedString) // "NewString"
/// ```
///  - Parameters:
///     - key: A key in the current user‘s defaults database.
///     - defaultValue: The value used if no object is found in UserDefaults for key.
@propertyWrapper struct UserDefaultsStorage<Value: Codable> {
    let key: String
    let defaultValue: Value
    private let defaults: UserDefaults = .standard

    public var wrappedValue: Value {
        get {
            guard let data = defaults.data(forKey: key) else { return defaultValue }
            return (try? JSONDecoder().decode(Value.self, from: data)) ?? defaultValue
        }
        nonmutating set {
            let data = try? JSONEncoder().encode(newValue)
            defaults.set(data, forKey: key)
        }
    }
}
