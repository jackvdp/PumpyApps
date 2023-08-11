//
//  GetAMStation.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 11/08/2023.
//

import Foundation

class GetStationUseCase {
    
    private let stationTracksGateway = GetStationTracksGateway()
    private let stationGateway = GetStationGateway()
    
    func execute(stationID: String,
                 authManager: AuthorisationManager,
                 completion: @escaping (AMStation?, ErrorMessage?) -> ()) {
        
        Task {
            let (_, tracks) = await stationTracksGateway.post(stationID: stationID, authManager: authManager)
            let (_, stations) = await stationGateway.get(stationID: stationID, authManager: authManager)
            
            guard let station = stations?.data.first, let tracks else {
                completion(nil, ErrorMessage("No station found", "No station found"))
                return
            }
            
            let analyticTracks: [Track] = tracks.data.map { trk in
                var genres: [String] {
                    var genres = trk.attributes.genreNames
                    genres.removeAll(where: { $0 == "Music"})
                    return genres
                }
                return Track(
                    title: trk.attributes.name,
                    artist: trk.attributes.artistName,
                    album: trk.attributes.albumName,
                    isrc: trk.attributes.isrc,
                    artworkURL: trk.attributes.artwork.url,
                    previewUrl: trk.attributes.previews.first?.url,
                    isExplicit: false,
                    sourceID: trk.id,
                    authManager: authManager,
                    appleMusicItem: AppleMusicItem(
                      isrc: trk.attributes.isrc,
                      id: trk.id,
                      name: trk.attributes.name,
                      artistName: trk.attributes.artistName,
                      artworkURL: trk.attributes.artwork.url,
                      genres: genres,
                      type: .track
                    )
                )
            }
            
            let amStation = AMStation(
                name: station.name,
                curator: "",
                tracks: analyticTracks,
                artworkURL: station.artwork?.url(width: K.MusicStore.artworkKey, height: K.MusicStore.artworkKey)?.absoluteString,
                description: nil,
                shortDescription: nil,
                sourceID: stationID,
                authManager: authManager
            )

            completion(amStation, nil)
        }
        
    }
    
}
