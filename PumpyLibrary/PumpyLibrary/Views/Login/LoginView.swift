//
//  LoginView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/01/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct LoginView<A: AccountManagerProtocol>: View {
    public init(buttonText: String, pageSwitchText: String) {
        self.buttonText = buttonText
        self.pageSwitchText = pageSwitchText
    }
    
    @EnvironmentObject var accountVM: A
    let buttonText: String
    let pageSwitchText: String
    
    public var body: some View {
        VStack(spacing: 20) {
            PumpyView()
            Spacer()
            signinFields
            switchLoginRegisterButton
            Spacer()
            signinAsGuestButton
        }
        .padding(.all, 10.0)
        .overlay(ActivityView(activityIndicatorVisible: $accountVM.activityIndicatorVisible))
        .background(backgroundGradient)
        .alert(isPresented: $accountVM.showingAlert) {
            Alert(title: Text("Error"),
                  message: Text(accountVM.errorAlert),
                  dismissButton: .default(Text("Got it!")))
        }
        .onAppear() {
            accountVM.attemptSign()
        }
        .accentColor(.white)
    }

    var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [.black, .pumpyBlue, .pumpyPurple, .pumpyPink]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    var signinFields: some View {
        TextFieldView(string: $accountVM.usernameTF, placeholder: "E-mail address")
        SecureTextFieldView(string: $accountVM.passwordTF, placeholder: "Enter your password")
        LogInButtonView(title: buttonText) { accountVM.attemptSign() }
    }
    
    var switchLoginRegisterButton: some View {
        Button(action: {
            accountVM.togglePageState()
        }) {
            Text(pageSwitchText)
                .foregroundColor(.white)
                .underline()
        }
    }
    
    var signinAsGuestButton: some View {
        Button(action: {
            accountVM.signinAsGuest()
        }) {
            Text("Sign in as guest")
                .foregroundColor(.white)
                .underline()
        }
    }
}

// MARK: Pumpy Logo

public struct PumpyView: View {
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    
    public init() {}
    
    public var body: some View {
        Image(K.pumpyImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: hSize == .regular || vSize == .regular ? 400 : nil)
    }
}

// MARK: - Text fields

struct TextFieldView: View {
    @Binding var string: String
    let placeholder: String
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    
    var body: some View {
        TextField(placeholder, text: $string)
            .textContentType(.emailAddress)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
            .colorScheme(.light)
            .accentColor(.pumpyPink)
            .padding(.horizontal, 10)
            .frame(maxWidth: hSize == .regular || vSize == .regular ? 400 : nil)
    }
}

struct SecureTextFieldView: View {
    @Binding var string: String
    let placeholder: String
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    
    var body: some View {
        SecureField(placeholder, text: $string)
            .textContentType(.password)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
            .colorScheme(.light)
            .accentColor(.pumpyPink)
            .padding(.horizontal, 10)
            .frame(maxWidth: hSize == .regular || vSize == .regular ? 400 : nil)
    }
}

// MARK: - Login Button

struct LogInButtonView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .frame(minWidth: 100, maxWidth: 100, minHeight: 40, maxHeight: 40)
        .foregroundColor(.pumpyPink)
        .background(Color.white)
        .cornerRadius(10)
        .padding()
    }
}

// MARK: - Previews

#if DEBUG
struct LoginView_Previews: PreviewProvider {
        
    static var previews: some View {
        LoginView<MockAccountManager>(buttonText: "Login", pageSwitchText: "Register")
            .environmentObject(MockAccountManager())
    }
}
#endif
