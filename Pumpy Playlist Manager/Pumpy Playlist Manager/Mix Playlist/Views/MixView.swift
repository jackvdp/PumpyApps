//
//  CreateView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/04/2022.
//

import SwiftUI
import PumpyAnalytics

struct MixView: View {
    
    @EnvironmentObject var authManager: AuthorisationManager
    @ObservedObject var navManager: MixNavigationManager
    
    let transition = AnyTransition.asymmetric(
        insertion: .move(edge: .leading),
        removal: .move(edge: .trailing)
    )
    
    var body: some View {
        VStack {
            Header(navManager: navManager)
            Spacer(minLength: 0)
            switch navManager.currentPage {
            case .staging:
                MixGridView(gridVM: MixGridViewModel(navigator: navManager))
            case .playlistPreview(let playlist):
                GetPlaylistView(playlist, authManager: authManager)
            case .mixerSettings(let playlists, let tracks):
                MixLoadView(playlists,
                            tracks: tracks,
                            authManager: authManager)
            case .sortedCustomPlaylists(_, _, let newPlaylists):
                MixResultsVew(newPlaylists)
            }
            Spacer(minLength: 0)
        }
        .animation(.default, value: navManager.currentPage)
        .environmentObject(navManager)
    }
    
}

struct MixView_Previews: PreviewProvider {
    
    static let libraryManager = SavedPlaylistController()
    static let createNavMan = MixNavigationManager()
    
    static var previews: some View {
        MixView(navManager: createNavMan)
            .environmentObject(libraryManager)
            .environmentObject(PlayerManager())
            .environmentObject(AccountManager())
    }
}
