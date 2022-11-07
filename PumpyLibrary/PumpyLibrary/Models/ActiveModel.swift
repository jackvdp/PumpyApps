//
//  ActiveModel.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/08/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import UIKit

public struct ActiveModel: Codable {
    public init(activeStatus: ActiveStatus) {
        self.activeStatus = activeStatus
    }
    
    var deviceName = UIDevice.current.name
    var date = Date()
    let activeStatus: ActiveStatus
}

public enum ActiveStatus: String, Codable {
    case loggedIn = "loggedIn"
    case loggedOut = "loggedOut"
    case background = "background"
    case terminated = "terminated"
}
