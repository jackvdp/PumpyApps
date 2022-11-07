//
//  ButtonsView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/02/2022.
//

import SwiftUI
import ToastUI
import PumpyAnalytics

struct ButtonsView<V: PlayableViewModel>: View {
    @EnvironmentObject var playerManager: PlayerManager
    @EnvironmentObject var libraryManager: SavedPlaylistController
    @EnvironmentObject var libraryNavManager: SavedNavigationManager
    @EnvironmentObject var authManager: AuthorisationManager
    @ObservedObject var playlistVM: V
    @ObservedObject var observedVM: ObserveTracksViewModel
    @State var popooverShowing = false
    @State var showDownloadSheet = false
    
    var body: some View {
        HStack(alignment: .top) {
            CircularButtonView(size: 50,
                               systemName: "play.fill",
                               font: .largeTitle) {
                playerManager.playQueue(playlistVM.playlist.tracks.shuffled(), from: playlistVM.playlist.name)
            }
            CircularButtonView(size: 35,
                               systemName: libraryManager.isInLibrary(playlistVM.playlist.snapshot) ? "checkmark" : "plus",
                               font: .title2) {
                popooverShowing = true
            }
                               .popover(isPresented: $popooverShowing, arrowEdge: .bottom) {
                                   VStack(alignment: .leading, spacing: 8) {
                                       PlaylistContexMenu(playlist: playlistVM.getCorrectSnapshot(),
                                                         onHoverEnabled: true)
                                   }
                                   .buttonStyle(.plain)
                                   .padding()
                               }
            CircularButtonView(size: 35,
                               systemName: "arrow.down",
                               font: .title2) {
                showDownloadSheet = true
            }
        }
        .sheet(isPresented: $showDownloadSheet) {
            DownloadView(downloadVM: DownloadViewModel(playlistName: playlistVM.playlist.name,
                                                       tracks: playlistVM.playlist.tracks,
                                                       authManager: authManager),
                         observeVM: observedVM,
                         showingSheet: $showDownloadSheet)
        }
    }
}

struct ButtonsView_Previews: PreviewProvider {
    static let dbController = SavedPlaylistController()
    static var previews: some View {
        ButtonsView(playlistVM: PlaylistViewModel(MockData.playlist,
                                                  snapshot: MockData.snapshot,
                                                  controller: dbController),
                    observedVM: ObserveTracksViewModel(MockData.playlist))
        .environmentObject(PlayerManager())
        .environmentObject(dbController)
    }
}

