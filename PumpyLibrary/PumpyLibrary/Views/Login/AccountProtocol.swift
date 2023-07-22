//
//  AccountManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/08/2022.
//

import Foundation
import SwiftUI

public protocol AccountManagerProtocol: ObservableObject {
    
    associatedtype U: UserProtocol
    
    var usernameTF: String { get set }
    var passwordTF: String { get set }
    var showingAlert: Bool { get set }
    var pageState: SignType { get set }
    var activityIndicatorVisible: Bool { get set }
    var errorAlert: String { get set }
    func attemptSign()
    func togglePageState()
    func signOut()
    func deleteAccount(completion: @escaping (Bool)->())
    func changePassword(newPassword: String,
                        completion: @escaping (Bool)->())
    func signinAsGuest()
    var user: U? { get set }
}

class MockAccountManager: AccountManagerProtocol {
    
    static let shared = MockAccountManager()
    @Published var pageState: SignType = .login
    @Published var usernameTF = String()
    @Published var passwordTF = String()
    @Published var activityIndicatorVisible = false
    @Published var errorAlert = String()
    @Published var showingAlert = false
    var user: MockUser?
    
    func loadSavedDetails() { }
    
    func togglePageState() {
        switch pageState {
        case .login:
            pageState = .register
        case .register:
            pageState = .login
        }
    }
    
    func attemptSign() { }

    func loginSucceed(_ email: String) { }
    
    func signOut() {}
    
    func deleteAccount(completion: @escaping (Bool)->()) {}
    
    func changePassword(newPassword: String,
                        completion: @escaping (Bool)->()) {}
    
    func signinAsGuest() {}
}

public enum SignType {
    case login
    case register
}


