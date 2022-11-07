//
//  AccountManager.swift
//  GraphQL Test
//
//  Created by Jack Vanderpump on 10/02/2022.
//

import Foundation
import SwiftUI

class AccountManager: ObservableObject {
    
    let sybAccount = SYBAccount()
    let fireAccount: FirestoreAccount
    let savedPlaylistsController: SavedPlaylistController
    
    init() {
        let spController = SavedPlaylistController()
        self.savedPlaylistsController = spController
        self.fireAccount = FirestoreAccount(controller: spController)
    }
    
}
