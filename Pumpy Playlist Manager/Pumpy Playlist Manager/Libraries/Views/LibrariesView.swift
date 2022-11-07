//
//  HomeView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/04/2022.
//

import SwiftUI
import PumpyAnalytics

struct LibrariesView: View {
    
    @ObservedObject var navManager: LibrariesNavigationManager
    @EnvironmentObject var authManager: AuthorisationManager
    
    var body: some View {
        VStack {
            Header(navManager: navManager)
            Spacer(minLength: 0)
            switch navManager.currentPage {
            case .libraries:
                LibrariesGridView(navManager: navManager)
            case .playlist(let playlist):
                GetPlaylistView(playlist,
                                authManager: authManager)
            }
            Spacer(minLength: 0)
        }
        .animation(.default, value: navManager.currentPage)
        .environmentObject(navManager)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        LibrariesView(navManager: LibrariesNavigationManager())
    }
}
