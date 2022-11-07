//
//  GetAMPlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/04/2022.
//

import Foundation
import Alamofire
import MusicKit

class GetAMPlaylist {
    
    let authManager: AuthorisationManager
    let libraryPlaylist: PlaylistSnapshot
    
    init(libraryPlaylist: PlaylistSnapshot, authManager: AuthorisationManager) {
        self.authManager = authManager
        self.libraryPlaylist = libraryPlaylist
    }
    
    func execute(amID: String, completion: @escaping (AMPlaylist?, Error?) -> ()) {
        AMPlaylistAPI().get(id: amID, authManager: authManager) { playlist, tracks, error in
            if let error = error {
                print(error)
                completion(nil, error)
                return
            }
            
            guard let playlist = playlist else { return }
            
            let amPlaylist = self.makePlaylist(playlist: playlist, tracks: tracks, authManager: self.authManager)
            
            completion(amPlaylist, error)
        }
    }
    
    private func makePlaylist(playlist: MusicKit.Playlist, tracks amTracks: [MusicKit.Track], authManager: AuthorisationManager) -> AMPlaylist {
        
        let tracks: [Track] = amTracks.compactMap { trk in

            if let isrc = trk.isrc {
                
                let artworkURL = getGenericArtworkString(trk.artwork)
                var genres = trk.genreNames
                genres.removeAll(where: { $0 == "Music" })
     
                return Track(title: trk.title,
                             artist: trk.artistName,
                             album: trk.albumTitle ?? "",
                             isrc: isrc,
                             artworkURL: artworkURL,
                             previewUrl: trk.previewAssets?.first?.url?.absoluteString,
                             isExplicit: trk.contentRating == .explicit,
                             sourceID: trk.id.rawValue,
                             authManager: authManager,
                             appleMusicItem: AppleMusicItem(
                                isrc: isrc,
                                id: trk.id.rawValue,
                                name: trk.title,
                                artistName: trk.artistName,
                                artworkURL: artworkURL,
                                genres: genres,
                                type: .playlist))
            }
            return nil
        }
 
        return AMPlaylist(
            name: playlist.name,
            curator: playlist.curatorName ?? "Apple Music",
            tracks: tracks,
            artworkURL: getGenericArtworkString(playlist.artwork),
            description: playlist.standardDescription,
            shortDescription: playlist.standardDescription,
            sourceID: playlist.id.rawValue,
            authManager: authManager
        )
    }
    
    func getGenericArtworkString(_ artwork: Artwork?) -> String? {
        let key = 135792468
        guard let artworkString = artwork?.url(width: key, height: key)?.absoluteString else { return nil }
        return artworkString.replacingOccurrences(of: "\(key)", with: "%w")
    }
    
}
