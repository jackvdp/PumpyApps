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
        Group {
            if case let .account(user) = accountVM.user?.username {
                loggedInView(user)
            } else {
                guestView
            }
        }
        .listStyle(.plain)
        .pumpyBackground()
        .navigationBarTitle("Account")
        .alert(isPresented: $showError) {
            standardAlertBox
        }
    }
    
    var guestView: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("**You're currently signed in as a guest.**").underline()
                Text("By creating an account, you unlock a range of benefits including:\n\n• **Playlist Automation:** Save your personalized playlist automation schedule for a seamless music experience.\n\n• **Track Preferences:** Like your favorite songs to easily access them later or block tracks that you don't prefer, tailoring the music experience to your taste")
                    .multilineTextAlignment(.leading)
                Button("Sign in") {
                    accountVM.signOut()
                }
                .buttonStyle(.borderedProminent)
                .tint(.pumpyPink)
                Text("*No personal information is recorded. The only data stored are user settings, liked/blocked tracks and playlist schedule.*").opacity(0.5).font(.callout)
            }
            .padding(32)
            .multilineTextAlignment(.center)
        }
    }
    
    func loggedInView(_ user: String) -> some View {
        PumpyList {
            accountButtons
            versionLabel(user)
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
    
    func versionLabel(_ user: String) -> some View {
        Text("Account: \(user) | v\(K.versionNumber)")
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
        NavigationView {
            AccountView<MockAccountManager>()
        }
        .preferredColorScheme(.dark)
        .environmentObject(MockAccountManager())
    }
}
