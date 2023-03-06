//
//  ItemDetailViewModel.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 13/09/2022.
//

import SwiftUI
import PumpyAnalytics

class ItemDetailViewModel: ObservableObject {
    
    @Published var pageState = PageState.loading
    
    func getItem(snapshot: PlaylistSnapshot, authManager: AuthorisationManager) {
        if snapshot.sourceID.contains("pl") {
            getPlaylist(snapshot: snapshot, authManager: authManager)
        } else {
            getAlbum(id: snapshot.sourceID, authManager: authManager)
        }
    }
    
    private func getPlaylist(snapshot: PlaylistSnapshot, authManager: AuthorisationManager) {
        
        PlaylistController().get(libraryPlaylist: snapshot,
                                 authManager: authManager) { [weak self] playlist, error in
            
            guard let self = self else { return }
            
            guard let playlist = playlist else {
                print("\(error?.title ?? "") \(error?.message ?? "")")
                self.pageState = .failed
                return
            }
            
            let tracks = self.convertTracksToConstructedTracks(playlist.tracks)
            
            let constructedPlaylist = ConstructedPlaylist(title: playlist.name,
                                                          songs: tracks,
                                                          cloudGlobalID: playlist.sourceID,
                                                          artworkURL: playlist.artworkURL)
            
            DispatchQueue.main.async {
                self.pageState = .success(constructedPlaylist)
            }
        }
        
    }
    
    private func getAlbum(id: String, authManager: AuthorisationManager) {
        
        AlbumController().get(albumID: id, authManager: authManager) { [weak self] amAlbum, error in
            guard let self = self else { return }
            
            guard let amAlbum = amAlbum else {
                print("\(error?.title ?? "") \(error?.message ?? "")")
                self.pageState = .failed
                return
            }
            
            let tracks = self.convertTracksToConstructedTracks(amAlbum.tracks)
            
            let constructedPlaylist = ConstructedPlaylist(title: amAlbum.name,
                                                          songs: tracks,
                                                          cloudGlobalID: amAlbum.sourceID,
                                                          artworkURL: amAlbum.artworkURL)
            
            DispatchQueue.main.async {
                self.pageState = .success(constructedPlaylist)
            }
        }
        
    }
    
    func convertTracksToConstructedTracks(_ tracks: [PumpyAnalytics.Track]) -> [ConstructedTrack] {
        return tracks.compactMap { trk in
            ConstructedTrack(title: trk.title,
                             artist: trk.artist,
                             artworkURL: trk.artworkURL,
                             playbackStoreID: trk.sourceID,
                             isExplicitItem: trk.isExplicit)
        }
    }
    
    enum PageState: Equatable {
        case loading, success(ConstructedPlaylist), failed
        
        static func == (lhs: ItemDetailViewModel.PageState, rhs: ItemDetailViewModel.PageState) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case (.success, .success):
                return true
            case (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
}
