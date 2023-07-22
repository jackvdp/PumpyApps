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
    @StateObject private var toastManager = ToastManager()
    
    var body: some View {
        VStack {
            if let user = accountManager.user {
                UserView(user: user)
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
        .environmentObject(toastManager)
    }
    
    var loginView: some View {
        LoginView<AccountManager>(
            buttonText: "Log In",
            pageSwitchText: "Register"
        )
    }
    
    var registerView: some View {
        LoginView<AccountManager>(
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
