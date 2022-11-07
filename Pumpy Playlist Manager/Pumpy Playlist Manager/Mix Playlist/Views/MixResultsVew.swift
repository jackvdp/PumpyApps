//
//  SortedPlaylistsVew.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 10/03/2022.
//

import SwiftUI
import PumpyAnalytics

struct MixResultsVew: View {
    
    @StateObject var mixResultsVM: MixResultsViewModel
    
    init(_ playlists: [CustomPlaylist]) {
        _mixResultsVM = StateObject(
            wrappedValue: MixResultsViewModel(
                playlists: playlists
            )
        )
    }
    
    var body: some View {
        VStack {
            Picker("Playlists:", selection: $mixResultsVM.selectedPlaylist) {
                ForEach(mixResultsVM.playlists) { playlist in
                    Text("\(playlist.name ?? "")")
                        .tag(playlist as CustomPlaylist)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .frame(width: 450)
            MixPlaylistView(playlist: mixResultsVM.selectedPlaylist)
            Spacer()
        }
        .padding()
    }
}

struct SortedPlaylistsVew_Previews: PreviewProvider {

    static var previews: some View {
        MixResultsVew([MockData.customPlaylist])
    }
}

struct MixPlaylistView: View {
    
    var playlist: CustomPlaylist
    @EnvironmentObject var savedPlaylistController: SavedPlaylistController
    
    var body: some View {
        PlaylistView(playlistVM: PlaylistViewModel(
            playlist,
            snapshot: nil,
            controller: savedPlaylistController
        ), observeVM: ObserveTracksViewModel(playlist))
    }
    
}
