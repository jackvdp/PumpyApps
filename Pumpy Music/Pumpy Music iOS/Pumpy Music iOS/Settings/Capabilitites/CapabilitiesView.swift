//
//  CapabilitiesView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 15/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct CapabilitiesView: View {
    
    @StateObject var capaVM = CapabilitiesViewModel()
    @EnvironmentObject var accountVM: AccountManager
    
    var body: some View {
        Form {
            Section {
                CheckRowView(text: "Music Authorised",
                             granted: capaVM.libraryAccess,
                             action: capaVM.getLibraryAccess)
                CheckRowView(text: "Store Authorised",
                             granted: capaVM.storeAccess,
                             action: {})
                CheckRowView(text: "Notifications Authorised",
                             granted: capaVM.notificationsAllowed,
                             action: capaVM.getNotificationAccesss)
                CheckRowView(text: "Logged in to Pumpy",
                             granted: (accountVM.user != nil),
                             action: {
                                accountVM.user = nil
                             })
                CheckRowView(text: "Music Token",
                             granted: capaVM.tokenRecieved,
                             action: {})
            }
        }
        .navigationBarTitle("Capabilities")
    }
}

struct CapabilitiesView_Previews: PreviewProvider {
    static var previews: some View {
        CapabilitiesView()
            .environmentObject(AccountManager())
    }
}

struct CheckRowView: View {
    
    let text: String
    let granted: Bool
    let action: () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            Text(text)
            Spacer()
            if granted {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color.pumpyPink)
                        .frame(width: 20, height: 20)
                    Image(systemName: "checkmark")
                        .font(Font.system(size: 10, weight: .bold))
                        .shadow(color: Color.black, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
                .transition(.opacity)
            } else {
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 2)
                    .frame(width: 20, height: 20)
            }
        }
        .onTapGesture {
            if !granted {
                action()
            }
        }
    }
}
