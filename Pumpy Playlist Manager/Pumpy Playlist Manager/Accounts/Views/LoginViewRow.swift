//
//  LoginViewRow.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/02/2022.
//

import SwiftUI
import ActivityIndicatorView

struct LoginViewRow: View {
    
    @Binding var username: String
    @Binding var password: String
    @Binding var isLoggingIn: Bool
    var loginMethod: () -> ()
    
    var body: some View {
        ZStack {
            VStack {
                TextField(
                    "Email address",
                    text: $username
                )
                    .disableAutocorrection(true)
                SecureField(
                    "Password",
                    text: $password
                )
                Button("Log in") {
                    loginMethod()
                }
                .padding()
            }
            .disabled(isLoggingIn)
            VStack {
                AppActivityIndicatorView(isVisible: $isLoggingIn)
            }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .background(
            Rectangle()
                .foregroundColor(Color(NSColor.controlBackgroundColor))
                .cornerRadius(10)
        )
    }
}

struct LoginViewRow_Previews: PreviewProvider {
    
    static var previews: some View {
        LoginViewRow(username: .constant("username@me.com"),
                     password: .constant("ewfkernrjktgnrtjkg"),
                     isLoggingIn: .constant(true),
                     loginMethod: {return})
    }
}
