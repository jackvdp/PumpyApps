//
//  LoginNavigationManager.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 03/03/2022.
//

import Foundation

class AccountsNavigationManager: NavigationManager {
    @Published var currentPage: LoginNavigation = .login
}

enum LoginNavigation: NavigationSection {
        
    case login

    func defaultPage() -> LoginNavigation {
        return .login
    }
    
    func headerTitle() -> String {
        switch self {
        case .login:
            return "Accounts"
        }
    }
    
    func previousPage() -> LoginNavigation? {
        switch self {
        case .login:
            return nil
        }
    }
    
}
