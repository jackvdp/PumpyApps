//
//  TextPlaylistView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 31/10/2022.
//

import SwiftUI

struct TextPlaylistView: View {
    
    @StateObject var navManager = TextNavigationManager()
    @EnvironmentObject var savedPlaylistController: SavedPlaylistController
    
    var body: some View {
        VStack {
            Header(navManager: navManager)
            Spacer(minLength: 0)
            switch navManager.currentPage {
            case .text:
                TextToPlaylistView()
            case .playlist(let playlist):
                PlaylistView(playlistVM: PlaylistViewModel(playlist,
                                                           snapshot: nil,
                                                           controller: savedPlaylistController),
                             observeVM: ObserveTracksViewModel(playlist))
                .padding()
            }
            Spacer(minLength: 0)
        }
        .animation(.default, value: navManager.currentPage)
        .environmentObject(navManager)
    }
}

struct TextPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        TextPlaylistView()
    }
}
