//
//  PlaylistView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/02/2022.
//

import SwiftUI
import ActivityIndicatorView
import PumpyAnalytics

struct GetPlaylistView: View {
    
    @StateObject var getPlaylistVM: GetPlaylistViewModel
    @EnvironmentObject var libManager: SavedPlaylistController
    
    init(_ playlist: PlaylistSnapshot, authManager: AuthorisationManager) {
        _getPlaylistVM = StateObject(wrappedValue: GetPlaylistViewModel(libraryPlaylist: playlist, authManager: authManager))
    }
    
    var body: some View {
        VStack {
            if let playlist = getPlaylistVM.playlistRecieved {
                PlaylistView(playlistVM:
                                PlaylistViewModel(
                                    playlist,
                                    snapshot: getPlaylistVM.libraryPlaylist,
                                    controller: libManager),
                             observeVM: ObserveTracksViewModel(playlist))
            } else {
                AppActivityIndicatorView(isVisible: $getPlaylistVM.isSearching)
            }
        }
        .padding()
        .alert(getPlaylistVM.errorMessage.title, isPresented: $getPlaylistVM.showError) {
            Button("OK") {}
        } message: {
            Text(getPlaylistVM.errorMessage.message)
        }
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        GetPlaylistView(MockData.snapshot,
                        authManager: AuthorisationManager())
    }
}


