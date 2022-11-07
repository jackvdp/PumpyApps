//
//  LibraryView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/02/2022.
//

import SwiftUI
import PumpyAnalytics

struct SavedView: View {
    
    @EnvironmentObject var libraryManager: SavedPlaylistController
    @EnvironmentObject var authManager: AuthorisationManager
    @ObservedObject var navManager: SavedNavigationManager
    
    var body: some View {
        VStack {
            Header(navManager: navManager)
            Spacer(minLength: 0)
            switch navManager.currentPage {
            case .saved:
                SavedGridView(navigator: navManager)
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

struct LibraryView_Previews: PreviewProvider {
    
    static let libraryManager = SavedPlaylistController()
    static let libNavMan = SavedNavigationManager()
    
    static var previews: some View {
        return SavedView(navManager: libNavMan)
            .environmentObject(libraryManager)
            .environmentObject(PlayerManager())
            .environmentObject(AccountManager())
            .frame(width: 800, height: 400)
    }
}
