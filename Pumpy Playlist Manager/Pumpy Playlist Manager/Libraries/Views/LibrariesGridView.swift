//
//  HomeView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 28/03/2022.
//

import SwiftUI
import MusicKit
import PumpyAnalytics

struct LibrariesGridView: View {
    
    @EnvironmentObject var homeManager: LibrariesManager
    @StateObject var gridVM: LibrariesGridViewModel
    @EnvironmentObject var authManager: AuthorisationManager

    init(navManager: LibrariesNavigationManager) {
        _gridVM = StateObject(wrappedValue: LibrariesGridViewModel(navigator: navManager))
    }
    
    var body: some View {
        ScrollView {
            ProviderView(label: "Apple Music:",
                         libraryPlaylists: homeManager.amLibPlaylists,
                         isSearching: homeManager.isSearching,
                         gridVM: gridVM)
        }
    }
     
}

struct HomeGridView_Previews: PreviewProvider {
    
    static let hm = LibrariesManager()
    
    static var previews: some View {
        hm.amLibPlaylists = MockData.snapshots
        hm.isSearching = false
        return LibrariesGridView(navManager: LibrariesNavigationManager())
            .environmentObject(PlayerManager())
            .environmentObject(AccountManager())
            .environmentObject(SavedPlaylistController())
            .environmentObject(AuthorisationManager())
            .environmentObject(hm)
    }
}
