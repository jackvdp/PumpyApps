//
//  SYBAccount.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/02/2022.
//

import Foundation
import Apollo
import PumpyAnalytics

class SYBAccount: Account {
    
    @Published var username: String = String()
    @Published var password: String = String()
    @Published var loggedIn: Bool = false
    @Published var loggingIn: Bool = false
    @Published var token: String?
    
    init() {
        retrieveSavedDetails()
    }
    
    func logIn() {
        if !loggingIn {
            loggingIn = true
            let loginMutation = LoginMutation(email: username, password: password)
            
            ApolloClass.shared.client.perform(mutation: loginMutation) { result in
                self.loggingIn = false
                switch result {
                case .success(let result):
                    print("Got data")
                    if let token = result.data?.loginUser?.token {
                        self.respondToLogIn(username: self.username,
                                            password: self.password,
                                            token: token)
                    }
                case .failure(let error):
                    print("Error loading data \(error)")
                }
            }
        }
    }
    
    func logOut() {
        token = ""
        password = ""
        UserDefaults.standard.set("", forKey: K.KeychainKeys.sybPasswordKey)
        loggedIn = false
    }
    

    func respondToLogIn(username: String, password: String, token: String?) {
        self.token = token
        UserDefaults.standard.set(token, forKey: K.KeychainKeys.sybTokenKey)
        UserDefaults.standard.set(username, forKey: K.KeychainKeys.sybUsernameKey)
        UserDefaults.standard.set(password, forKey: K.KeychainKeys.sybPasswordKey)
        loggedIn = true
    }
    
    func retrieveSavedDetails() {
        if let username = UserDefaults.standard.string(forKey: K.KeychainKeys.sybUsernameKey) {
            self.username = username
            if let password = UserDefaults.standard.string(forKey: K.KeychainKeys.sybPasswordKey) {
                self.password = password
                logIn()
            }
        }
    }
    
}

