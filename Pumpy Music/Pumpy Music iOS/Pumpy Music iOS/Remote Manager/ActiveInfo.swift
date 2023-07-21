//
//  ActiveInfo.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 04/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import Firebase
import PumpyLibrary

class ActiveInfo {
    
    static func save(_ activeStatus: ActiveStatus, for username: Username) {
        FireMethods.save(object: ActiveModel(activeStatus: activeStatus),
                         name: username,
                         documentName: K.FStore.activeStatus,
                         dataFieldName: K.FStore.activeStatus)
    }
    
}
