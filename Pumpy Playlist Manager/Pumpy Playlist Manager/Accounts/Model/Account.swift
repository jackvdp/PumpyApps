//
//  Account.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 11/06/2022.
//

import Foundation

protocol Account: ObservableObject {
    
    var username: String { get set }
    var password: String { get set }
    var loggedIn: Bool { get set }
    var loggingIn: Bool { get set}
    var token: String? { get set }
    
    func logIn()
    func logOut()
    func respondToLogIn(username: String, password: String, token: String?)
    func retrieveSavedDetails()
    
}
