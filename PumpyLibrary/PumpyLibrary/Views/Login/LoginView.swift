//
//  LoginView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/01/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import ActivityIndicatorView

public struct LoginView<A: AccountManagerProtocol>: View {
    public init(usernamePlaceholder: String, buttonText: String, pageSwitchText: String) {
        self.usernamePlaceholder = usernamePlaceholder
        self.buttonText = buttonText
        self.pageSwitchText = pageSwitchText
    }
    
    @EnvironmentObject var accountVM: A
    let usernamePlaceholder: String
    let buttonText: String
    let pageSwitchText: String
    @Namespace var background
    
    public var body: some View {
        ZStack {
            VStack {
                Spacer()
                PumpyView()
                Spacer()
                TextFieldView(string: $accountVM.usernameTF, placeholder: usernamePlaceholder)
                SecureTextFieldView(string: $accountVM.passwordTF, placeholder: "Enter your password")
                LogInButtonView(title: buttonText, action: {accountVM.attemptSign()})
                Spacer()
                Button(action: {
                    accountVM.togglePageState()
                }) {
                    Text(pageSwitchText)
                        .foregroundColor(.white)
                }
            }
            .padding(.all, 10.0)
            ActivityView(activityIndicatorVisible: $accountVM.activityIndicatorVisible)
        }
        .background(
            backgroundGradient
                .id(background)
        )
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
        LinearGradient(gradient: Gradient(colors: [.black, .pumpyBlue, .pumpyPurple, .pumpyPink]),
                       startPoint: .top,
                       endPoint: .bottom)
        .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
        
    static var previews: some View {
        LoginView<MockAccountManager>(usernamePlaceholder: "Login", buttonText: "Login", pageSwitchText: "Register")
            .environmentObject(MockAccountManager())
    }
}
#endif

public struct PumpyView: View {
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    
    public init() { }
    
    public var body: some View {
        Image(K.pumpyImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: hSize == .regular || vSize == .regular ? 400 : nil)
    }
}

struct TextFieldView: View {
    @Binding var string: String
    let placeholder: String
    @Environment(\.horizontalSizeClass) var hSize
    @Environment(\.verticalSizeClass) var vSize
    
    var body: some View {
        TextField(placeholder, text: $string)
            .textContentType(.emailAddress)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .colorScheme(.light)
            .accentColor(.pumpyPink)
            .padding(.all, 10)
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
            .textFieldStyle(.roundedBorder)
            .colorScheme(.light)
            .accentColor(.pumpyPink)
            .padding(.horizontal, 10)
            .padding(.bottom, 50)
            .frame(maxWidth: hSize == .regular || vSize == .regular ? 400 : nil)
    }
}

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
    }
}

public struct ActivityView: View {
    @Binding var activityIndicatorVisible: Bool
    let size: Double
    
    public init(activityIndicatorVisible: Binding<Bool>, size: Double = 50.0) {
        self._activityIndicatorVisible = activityIndicatorVisible
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .opacity(0.5)
                .isHidden(!activityIndicatorVisible)
            noBackground
        }
    }
    
    public var noBackground: some View {
        ActivityIndicatorView(isVisible: $activityIndicatorVisible, type: .arcs())
            .frame(width: size, height: size)
            .foregroundColor(Color.pumpyPink)
    }
}
