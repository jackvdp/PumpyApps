//
//  AccountView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 30/08/2022.
//

import SwiftUI

public struct AccountView<A:AccountManagerProtocol>: View {
    @State private var showingLogOutAlert = false
    @State var showError = false
    @State var errorMessage = String()
    @State var errorTitle = String()
    @State var passwordField = UITextField()
    @State var newPasswordField = UITextField()
    @EnvironmentObject var accountVM: A
    
    public init() {}
    
    public var body: some View {
        PumpyList {
            accountButtons
            versionLabel
        }
        .navigationBarTitle("Account")
        .alert(isPresented: $showError) {
            standardAlertBox
        }
    }
    
    var accountButtons: some View {
        Section {
            row(title: "Change Password", image: "key", action: showChangePasswordAlert)
            row(title: "Log Out", image: "arrow.down.left.circle", action: {showingLogOutAlert = true})
            .alert(isPresented: $showingLogOutAlert) {
                logOutAlert
            }
            row(title: "Delete Account", image: "person.crop.circle.badge.xmark", action: showDeleteAlert)
        }
        .buttonStyle(.plain)
        .foregroundColor(.white)
    }
    
    var versionLabel: some View {
        Text("Account: \("user.username") | v\(K.versionNumber)")
            .foregroundColor(.gray)
            .lineLimit(1)
            .padding(.horizontal)
    }
    
    var logOutAlert: Alert {
        Alert(
            title: Text("Sign Out?"),
            message: Text("Are you sure you want to log out?"),
            primaryButton: .destructive(Text("Sign Out")) {
                accountVM.signOut()
            },
            secondaryButton: .cancel()
        )
    }
    
    var standardAlertBox: Alert {
        Alert(title: Text(errorTitle),
              message: Text(errorMessage),
              dismissButton: .default(Text("Okay")))
    }
    
    func row(title: String, image: String, action: @escaping ()->()) -> some View {
        return Button {
            action()
        } label: {
            HStack {
                MenuRow(title: title, imageName: image)
                Spacer()
            }
            .contentShape(Rectangle())
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView<MockAccountManager>()
    }
}
