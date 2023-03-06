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
        switch snapshot.type {
        case .am(id: let id):
            if id.contains("pl") {
                getPlaylist(snapshot: snapshot, authManager: authManager)
            } else {
                getAlbum(id: id, authManager: authManager)
            }
        default:
            getPlaylist(snapshot: snapshot, authManager: authManager)
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
            
            playlist.getTracksData()
            
            DispatchQueue.main.async {
                self.pageState = .success(playlist)
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
            
            DispatchQueue.main.async {
                self.pageState = .success(amAlbum)
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
        case loading, success(PumpyAnalytics.Playlist), failed
        
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
