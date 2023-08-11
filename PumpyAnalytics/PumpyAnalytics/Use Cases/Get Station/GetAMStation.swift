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
            async let (_, tracksToFetch) = stationTracksGateway.post(stationID: stationID, authManager: authManager)
            async let (_, stationsToFetch) = stationGateway.get(stationID: stationID, authManager: authManager)
            let (tracks, stations) = await (tracksToFetch, stationsToFetch)
            
            guard let station = stations?.data.first, let tracks else {
                completion(nil, ErrorMessage(
                    "No station found", "One was nil: \(String(describing: tracks)), \(String(describing: stations))")
                )
                return
            }
            
            var analyticTracks: [Track] = tracks.data.map { trk in
                convertTrackToAnalyticsTrack(trk, authManager: authManager)
            }
            
            async let (_, secondTracksToFetch) = stationTracksGateway.post(stationID: stationID, authManager: authManager)
            if let secondTracks = await secondTracksToFetch {
                let secondAnalyticTracks: [Track] = secondTracks.data.compactMap { trk in
                    if !analyticTracks.contains(where: { $0.isrc == trk.attributes.isrc }) {
                        return convertTrackToAnalyticsTrack(trk, authManager: authManager)
                    }
                    return nil
                }
                analyticTracks.append(contentsOf: secondAnalyticTracks)
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
    
    private func convertTrackToAnalyticsTrack(_ trk: StationTracks.Datum, authManager: AuthorisationManager) -> Track {
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
    
}
