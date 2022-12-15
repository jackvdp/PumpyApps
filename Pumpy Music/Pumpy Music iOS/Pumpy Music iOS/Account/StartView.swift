//
//  StartView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary
import PumpyAnalytics

struct StartView: View {
    
    @StateObject var accountManager = AccountManager()
    
    var body: some View {
        VStack {
            if let user = accountManager.user {
                UserView()
                    .environmentObject(user)
            } else {
                switch accountManager.pageState {
                case .login:
                    loginView
                case .register:
                    registerView
                }
            }
        }
        .environmentObject(accountManager)
    }
    
    var loginView: some View {
        LoginView<AccountManager>(
            usernamePlaceholder: "Enter your username",
            buttonText: "Log In",
            pageSwitchText: "Register"
        )
    }
    
    var registerView: some View {
        LoginView<AccountManager>(
            usernamePlaceholder: "Enter your email address",
            buttonText: "Register",
            pageSwitchText: "Already have an account?"
        )
    }
    
}

#if DEBUG
struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(AccountManager())
    }
}
#endif
