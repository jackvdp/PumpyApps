//
//  CapabilitiesView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 15/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyAnalytics

struct CapabilitiesView: View {
    
    @StateObject var capaVM = CapabilitiesViewModel()
    @EnvironmentObject var authManager: AuthorisationManager
    
    var body: some View {
        PumpyList {
            CheckRowView(text: "Library Access Authorised",
                         granted: capaVM.libraryAccess,
                         action: capaVM.getLibraryAccess)
            CheckRowView(text: "Store Authorised",
                         granted: capaVM.storeAccess,
                         action: {})
            CheckRowView(text: "Apple Music Token",
                         granted: authManager.appleMusicToken != nil,
                         action: {})
            CheckRowView(text: "Spotify Token",
                         granted: authManager.spotifyToken != nil,
                         action: authManager.getSpotifyToken)
        }
        .listStyle(.plain)
        .pumpyBackground()
        .navigationBarTitle("Capabilities")
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

// MARK: Preview

struct CapabilitiesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CapabilitiesView()
        }
        .preferredColorScheme(.dark)
        .accentColor(.pumpyPink)
    }
}
