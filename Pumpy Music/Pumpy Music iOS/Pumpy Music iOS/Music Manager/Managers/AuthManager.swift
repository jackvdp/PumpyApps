//
//  AuthManager.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 28/08/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import PumpyAnalytics
import PumpyLibrary

extension AuthorisationManager: TokenProtocol {
    public var appleMusicStoreFront: String? {
        get {
            return storefront
        }
        set(newValue) {
            storefront = newValue
        }
    }
}
