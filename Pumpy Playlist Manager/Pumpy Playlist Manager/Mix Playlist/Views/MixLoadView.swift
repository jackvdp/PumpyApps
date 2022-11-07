//
//  CreatePlaylistView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 02/03/2022.
//

import SwiftUI
import PumpyAnalytics

struct MixLoadView: View {
    
    @ObservedObject var createPlaylistVM: MixLoadViewModel
    @EnvironmentObject var createNavManager: MixNavigationManager
    
    init(_ playlists: [PlaylistSnapshot],
         tracks: CustomPlaylist?,
         authManager: AuthorisationManager) {
        createPlaylistVM = MixLoadViewModel(playlists: playlists,
                                            tracks: tracks,
                                            authManager: authManager)
    }
    
    var body: some View {
        VStack {
            if let p = createPlaylistVM.customPlaylist {
                MixerView(mixerVM: MixerViewModel(p,
                                                  navManager: createNavManager),
                          observerVM: ObserveTracksViewModel(p))
            } else {
                AppActivityIndicatorView(isVisible: $createPlaylistVM.isSearching)
            }
        }
        .padding()
    }
}

struct CreatePlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        MixLoadView(MockData.snapshots,
                    tracks: nil,
                    authManager: AuthorisationManager())
    }
}
