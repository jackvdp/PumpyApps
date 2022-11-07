//
//  PlaylistMakerViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 04/03/2022.
//

import Foundation
import Combine
import PumpyAnalytics

class MixerViewModel: FilterableViewModel {
    let navManager: MixNavigationManager
    
    @Published var playlistName = String()
    @Published var splitBy: SortTracks = .peak
    @Published var sortAcending = false
    @Published var divideBy: DivideBy = .two
    
    init(_ playlist: CustomPlaylist, navManager: MixNavigationManager) {
        self.navManager = navManager
        super.init(playlist)
        playlist.getTracksData()
        setPlaylistName(playlist)
    }

    func createPlaylist() {
        guard case .mixerSettings(let snapshots, _) = navManager.currentPage else { return }
        guard let customPlaylist = playlist as? CustomPlaylist else { return }
        
        let logic = CustomPlaylistLogic(
            snapshots: snapshots,
            index: 0,
            divideBy: divideBy,
            sortBy: splitBy
        )
        
        let analysedTracks = FeaturesHelper.getAnalysedTracks(tracks: playlist.tracks)
        
        let playlists = PlaylistController().split(analysedTracks: analysedTracks,
                                                   playlistName: playlistName,
                                                   curator: playlist.curator,
                                                   logic: logic,
                                                   authManager: playlist.authManager)

        navManager.currentPage = .sortedCustomPlaylists(oldPlaylists: snapshots,
                                                        tracks: customPlaylist,
                                                        newPlaylists: playlists)
    }
    
    func setPlaylistName(_ customPlaylist: CustomPlaylist) {
        let snapshots = customPlaylist.playlistLogic.snapshots
        playlistName = snapshots
            .compactMap { $0.name }
            .joined(separator: "/")
    }
    
    
}

extension MixerViewModel: PlayableViewModel {
    func getCorrectSnapshot() -> PlaylistSnapshot {
        return playlist.snapshot
    }
    
    func deleteTracks(selectedTracks: Set<Track>) {
        playlist.tracks.removeAll(where: { selectedTracks.contains($0) })
    }
}
