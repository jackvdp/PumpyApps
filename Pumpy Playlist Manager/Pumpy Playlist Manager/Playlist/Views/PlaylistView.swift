//
//  PlaylistView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/02/2022.
//

import SwiftUI
import PumpyAnalytics

struct PlaylistView: View {
    @ObservedObject var playlistVM: PlaylistViewModel
    @ObservedObject var observeVM: ObserveTracksViewModel
    @StateObject private var columnsShowing = ColumnsShowing()
    
    var body: some View {
        VStack(alignment: .trailing) {
            DetailView(playlistVM: playlistVM,
                       observeVM: observeVM)
            SortSearchView(playlistVM: playlistVM,
                           showColumns: columnsShowing,
                           observeVM: observeVM)
            .padding([.horizontal, .top])
            TracksView(tracks: playlistVM.displayedTracks,
                       deleteAction: playlistVM.deleteTracks,
                       columnsShowing: columnsShowing)
            PlaylistStatusView(viewModel: observeVM)
        }
    }
    
}

struct RecievedPlaylistView_Previews: PreviewProvider {
    static let dbController = SavedPlaylistController()
    
    static var previews: some View {
        PlaylistView(playlistVM: PlaylistViewModel(MockData.playlist,
                                                   snapshot: MockData.snapshot,
                                                   controller: dbController),
                     observeVM: ObserveTracksViewModel(MockData.playlist))
            .environmentObject(PlayerManager())
            .environmentObject(dbController)
            .environmentObject(AuthorisationManager())
    }
}
