//
//  CacheCleaner.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 09/10/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class CacheCleaner {
    
    static func clear() {
        let artworkPath = "/var/mobile/Media/iTunes_Control/iTunes/Artwork/Originals/00/"
        do {
            try FileManager.default.removeItem(atPath: artworkPath)
        } catch {
            print(error)
        }
    }
    
}
