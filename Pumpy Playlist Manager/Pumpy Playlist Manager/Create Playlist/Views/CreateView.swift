//
//  CreateView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/06/2022.
//

import SwiftUI
import PumpyAnalytics

struct CreateView: View {
    
    @ObservedObject var navManager: CreateNavigationManager
    @EnvironmentObject var authManager: AuthorisationManager
    @EnvironmentObject var savedPlaylistController: SavedPlaylistController
    
    var body: some View {
        VStack {
            Header(navManager: navManager)
            Spacer(minLength: 0)
            switch navManager.currentPage {
            case .staging:
                CreateStagingView(createVM: CreateStagingViewModel(nav: navManager))
            case .createdPlaylist(let playlist):
                PlaylistView(playlistVM:
                                PlaylistViewModel(
                                    playlist,
                                    snapshot: nil,
                                    controller: savedPlaylistController),
                             observeVM: ObserveTracksViewModel(playlist)
                )
                .padding()
            }
            Spacer(minLength: 0)
        }
        .environmentObject(navManager)
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(navManager: CreateNavigationManager())
    }
}
