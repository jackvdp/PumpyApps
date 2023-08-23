//
//  AyncForEach.swift
//  PumpyShared
//
//  Created by Jack Vanderpump on 18/08/2023.
//

import Foundation

public extension Sequence {
    /// Will do each task sequentially
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}
