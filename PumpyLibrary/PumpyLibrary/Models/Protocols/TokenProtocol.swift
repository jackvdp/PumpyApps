//
//  TokenProtocol.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 10/08/2022.
//

import Foundation

public protocol TokenProtocol: ObservableObject {
    var appleMusicToken: String? { get set }
    var appleMusicStoreFront: String? { get set }
}

public class MockTokenManager: TokenProtocol {
    public init() {}
    public var appleMusicToken: String?
    public var appleMusicStoreFront: String?
}
