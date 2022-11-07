//
//  AccountSection.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 11/06/2022.
//

import SwiftUI

struct AccountSection<A: Account>: View {
    
    @ObservedObject var account: A
    var title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
            if account.loggedIn {
                LoggedInView(username: account.username,
                             signOutFunction: account.logOut)
            } else {
                LoginViewRow(
                    username: $account.username,
                    password: $account.password,
                    isLoggingIn: $account.loggingIn,
                    loginMethod: account.logIn)
            }
        }
    }
}

struct AccountSection_Previews: PreviewProvider {
    static var previews: some View {
        AccountSection(account: SYBAccount(), title: "SoundTrackYourBrand")
    }
}
