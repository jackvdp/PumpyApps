//
//  LoginView.swift
//  GraphQL Test
//
//  Created by Jack Vanderpump on 10/02/2022.
//

import SwiftUI

struct AccountsView: View {
    
    @EnvironmentObject var accountManager: AccountManager
    @StateObject var loginVan = AccountsNavigationManager()
    
    var body: some View {
        VStack {
            Header(navManager: loginVan)
            Spacer()
            VStack(spacing: 20) {
                AccountSection(account: accountManager.sybAccount, title: "SoundTrackYourBrand")
                AccountSection(account: accountManager.fireAccount, title: "Pumpy Account")
            }
            .listStyle(.plain)
            .padding()
            .frame(maxWidth: 600)
            Spacer()
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
            .environmentObject(AccountManager())
    }
}
