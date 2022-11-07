//
//  SearchTracks.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 28/05/2022.
//

import Foundation

class SearchAMTracks {
    
    var gateway: SearchTracksGatewayProtocol
    
    init(gateway: SearchTracksGatewayProtocol = SearchTracksGateway()) {
        self.gateway = gateway
    }
    
    func execute(term: String,
                 limit: Int,
                 authManager: AuthorisationManager,
                 completion: @escaping ([Track], ErrorMessage?) -> ()) {
        
        gateway.run(term, limit: limit, authManager: authManager) { results, code in
            
            guard let results = results else {
                completion([], ErrorMessage("Error", "Error fetching search tracks. Code: \(code)"))
                return
            }
            
            let songs = results.results.songs.data.compactMap { song in
                Track(title: song.attributes.name,
                      artist: song.attributes.artistName,
                      album: song.attributes.albumName,
                      isrc: song.attributes.isrc,
                      artworkURL: song.attributes.artwork.url,
                      previewUrl: song.attributes.previews.first?.url,
                      isExplicit: song.attributes.contentRating == "explicit",
                      sourceID: song.id,
                      authManager: authManager,
                      appleMusicItem: AppleMusicItem(isrc: song.attributes.isrc,
                                                     id: song.id,
                                                     name: song.attributes.name,
                                                     artistName: song.attributes.artistName,
                                                     genres: song.attributes.genreNames,
                                                     type: .track))
            }
            
            completion(songs, nil)
        }
        
    }
    
    
}
