//
//  AccountVM.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 02/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import PumpyLibrary

class AccountManager: AccountManagerProtocol {
    @Published var pageState: SignType = .login
    @Published var usernameTF = String()
    @Published var passwordTF = String()
    @Published var activityIndicatorVisible = false
    @Published var errorAlert = String()
    @Published var showingAlert = false
    
    @Published var user: User?
    
    let defaults = UserDefaults.standard
    
    init() {
        loadSavedDetails()
    }
    
    deinit {
        print("deinit Account Manager")
    }
    
    func loadSavedDetails() {
        if let name = defaults.string(forKey: K.username), let password = defaults.string(forKey: K.password) {
            usernameTF = name
            passwordTF = password
        }
    }
    
    func togglePageState() {
        switch pageState {
        case .login:
            pageState = .register
        case .register:
            pageState = .login
        }
    }
    
    func attemptSign() {
        if usernameTF != String() {
            activityIndicatorVisible = true
            switch pageState {
            case .login:
                attemptSignIn(usernameTF, passwordTF)
            default:
                attemptSignUp(usernameTF, passwordTF)
            }
        }
    }

    func attemptSignIn(_ name: String, _ password: String) {
        FirebaseStore.shared.signIn(name, password) { [weak self] email, error in
            self?.respondToLogin(email, error)
        }
    }
    
    func attemptSignUp(_ name: String, _ password: String) {
        FirebaseStore.shared.signUp(name, password) { [weak self] email, error in
            self?.respondToLogin(email, error)
        }
    }
    
    func respondToLogin(_ email: String?, _ error: Error?) {
        activityIndicatorVisible = false
        if let e = error {
            errorAlert = e.localizedDescription
            showingAlert = true
        } else {
            if let email = email {
                loginSucceed(email)
            } else {
                errorAlert = "Unknown Error"
                showingAlert = true
            }
        }
    }
    
    func loginSucceed(_ email: String) {
        user = User(username: .account(email.lowercased()))
        defaults.set(usernameTF.lowercased(), forKey: K.username)
        defaults.set(passwordTF, forKey: K.password)
    }
    
    func signOut() {
        usernameTF = String()
        passwordTF = String()
        user?.signOut()
        user = nil
    }
    
    func deleteAccount(completion: @escaping (Bool)->()) {
        
        FirebaseStore.shared.deleteAccount { [weak self] success in
            completion(success)
            guard let self = self else { return }
            if success {
                self.signOut()
                self.defaults.set("", forKey: K.username)
                self.defaults.set("", forKey: K.password)
            }
        }
    }
    
    func changePassword(newPassword: String,
                        completion: @escaping (Bool)->()) {
        
        FirebaseStore.shared.changePassword(newPassword: newPassword, completion: completion)
    }

}
