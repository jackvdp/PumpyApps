//
//  FireAccount.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/02/2022.
//

import Foundation
import Firebase
import PumpyAnalytics

class FirestoreAccount: Account {
    @Published var username = String()
    @Published var password = String()
    @Published var loggedIn = false
    @Published var loggingIn = false
    @Published var token: String?
    
    var savedPlaylsitsController: SavedPlaylistController
    
    init(controller: SavedPlaylistController) {
        savedPlaylsitsController = controller
        retrieveSavedDetails()
    }
    
    func logIn() {
        if !loggingIn {
            loggingIn = true
            Auth.auth().signIn(withEmail: username, password: password) { result, error in
                self.loggingIn = false
                
                guard error == nil else {
                    print(error.debugDescription)
                    return
                }
                if result != nil {
                    self.respondToLogIn(username: self.username, password: self.password, token: nil)
                }
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set("", forKey: K.KeychainKeys.firePassKey)
            password = ""
            loggedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func respondToLogIn(username: String, password: String, token: String?) {
        UserDefaults.standard.set(username, forKey: K.KeychainKeys.fireUserKey)
        UserDefaults.standard.set(password, forKey: K.KeychainKeys.firePassKey)
        loggedIn = true
        savedPlaylsitsController.signIn(username: username)
    }
    
    func retrieveSavedDetails() {
        if let username = UserDefaults.standard.string(forKey: K.KeychainKeys.fireUserKey) {
            self.username = username
            if let password = UserDefaults.standard.string(forKey: K.KeychainKeys.firePassKey) {
                self.password = password
                logIn()
            }
        }
    }
    
    
}
