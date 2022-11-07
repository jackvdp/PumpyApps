//
//  GetAmAlbum.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 19/09/2022.
//

import Foundation
import MusicKit

class GetAMAlbum {
    
    var gateway: AlbumGatewayProtocol
    
    init(gateway: AlbumGatewayProtocol = AlbumGateway()) {
        self.gateway = gateway
    }
    
    func execute(id: String, authManager: AuthorisationManager, completion: @escaping (AMAlbum?, ErrorMessage?) -> ()) {
        
        gateway.get(id: id, authManager: authManager) { album, code in
            
            guard let album = album?.data.first else {
                completion(nil, ErrorMessage("Error", "Error fetching album. Code: \(code)"))
                return
            }

            let tracks: [PumpyAnalytics.Track]? = album.tracks?.compactMap { trk in
                guard let isrc = trk.isrc else { return nil }
                return Track(title: trk.title,
                      artist: trk.artistName,
                      album: trk.albums?.first?.title ?? "",
                      isrc: isrc,
                      artworkURL: trk.artwork?.url(width: K.MusicStore.artworkKey, height: K.MusicStore.artworkKey)?.absoluteString,
                      previewUrl: trk.previewAssets?.first?.url?.absoluteString,
                      isExplicit: false,
                      sourceID: trk.id.rawValue,
                      authManager: authManager,
                      appleMusicItem: AppleMusicItem(isrc: isrc,
                                                     id: trk.id.rawValue,
                                                     name: trk.title,
                                                     artistName: trk.artistName,
                                                     artworkURL: trk.artwork?.url(width: K.MusicStore.artworkKey, height: K.MusicStore.artworkKey)?.absoluteString,
                                                     genres: trk.genreNames,
                                                     type: .album))
            }
            
            let amAlbum = AMAlbum(name: album.title,
                                  curator: album.artistName,
                                  tracks: tracks ?? [],
                                  artworkURL: album.artwork?.url(width: K.MusicStore.artworkKey, height: K.MusicStore.artworkKey)?.absoluteString,
                                  description: album.editorialNotes?.standard,
                                  shortDescription: album.editorialNotes?.short,
                                  sourceID: album.id.rawValue,
                                  authManager: authManager)

            completion(amAlbum, nil)
        }
        
    }
    
}
