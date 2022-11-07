//
//  CreatePlaylistFromSeeding.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 19/06/2022.
//

import Foundation

class CreatePlaylistFromSeeding {
    
    func execute(seeding: PlaylistSeeding,
                 authManager: AuthorisationManager,
                 completion: @escaping (Playlist?, ErrorMessage?) -> ()) {
        
        let query = constructQuery(seeding: seeding)
        
        SpotifyRecommendPlaylistGateway().run(query: query,
                                       authManager: authManager) { tracks, error in
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            let playlist = RecommendedPlaylist(name: "Recommended Playlist",
                                               tracks: tracks,
                                               authManager: authManager,
                                               sourceID: UUID().uuidString)
            
            completion(playlist, nil)
        }
        
    }
    
    func constructQuery(seeding: PlaylistSeeding) -> String {
        var queryString = String()
        
        queryString += trackArtistGenreSeeding(tracks: seeding.trackIDs,
                                            artists: seeding.artistIDs,
                                            genres: seeding.genres)
        
        
        queryString += "&limit=" + String(seeding.playlistSize)
        
        queryString += "&" + convertCustomSeeding(seeding.seeding)
        
        return queryString.makeURLSafe()
    }
    
    private func trackArtistGenreSeeding(tracks: [String],
                                      artists: [String],
                                      genres: [String]) -> String {
        
        var queryString = String()
        
        var tracksToEdit = tracks
        var artistsToEdit = artists
        var genresToEdit = genres
        
        while tracksToEdit.count > 5 {
            tracksToEdit.removeLast()
        }
        
        while artistsToEdit.count > (5 - tracksToEdit.count) {
            artistsToEdit.removeLast()
        }
        
        while genresToEdit.count > (5 - tracksToEdit.count - artistsToEdit.count) {
            genresToEdit.removeLast()
        }
        
        if tracksToEdit.count > 0 {
            let tracksJoined = tracksToEdit.joined(separator: ",")
            queryString += "seed_tracks=" + tracksJoined
        }
        
        if artistsToEdit.count > 0 {
            let artistsJoined = artistsToEdit.joined(separator: ",")
            queryString += "&seed_artists=" + artistsJoined
        }
        
        if genresToEdit.count > 0 {
            let genresJoined = genresToEdit.joined(separator: ",")
            queryString += "&seed_genres=" + genresJoined
        }
        
        return queryString
    }
    
//    private func convertAverageSeeding(_ seeding: AverageSeeding) -> String {
//        let danceSeed: String = "target_danceability=" + seeding.targetDanceability.description
//        let energySeed: String = "target_energy=" + seeding.targetEnergy.description
//        let popularitySeed: String = "target_popularity=" + seeding.targetPopularity.description
//        let tempoSeed: String = "target_tempo=" + seeding.targetBPM.description
//        let happinessSeed: String = "target_valence=" + seeding.targetHappiness.description
//        let loudnessSeed: String = "target_loudness=" + seeding.targetLoudness.description
//        let speechinessSeed: String = "target_speechiness=" + seeding.targetSpeechiness.description
//        let acousticSeed: String = "target_acousticness=" + seeding.targetAcoustic.description
//        
//        let array = [danceSeed,energySeed,popularitySeed,tempoSeed,happinessSeed,loudnessSeed,speechinessSeed,acousticSeed]
//        
//        return array.joined(separator: "&")
//    }
    
    private func convertCustomSeeding(_ seeding: CustomSeeding) -> String {
        let danceSeedMin: String = "min_danceability=" + seeding.minDanceability.description
        let energySeedMin: String = "min_energy=" + seeding.minEnergy.description
        let popularitySeedMin: String = "min_popularity=" + seeding.minPopularity.description
        let tempoSeedMin: String = "min_tempo=" + seeding.minBPM.description
        let happinessSeedMin: String = "min_valence=" + seeding.minHappiness.description
        let loudnessSeedMin: String = "min_loudness=" + seeding.minLoudness.description
        let speechinessSeedMin: String = "min_speechiness=" + seeding.minSpeechiness.description
        let acousticSeedMin: String = "min_acousticness=" + seeding.minAcoustic.description
        
        let danceSeedMax: String = "max_danceability=" + seeding.maxDanceability.description
        let energySeedMax: String = "max_energy=" + seeding.maxEnergy.description
        let popularitySeedMax: String = "max_popularity=" + seeding.maxPopularity.description
        let tempoSeedMax: String = "max_tempo=" + seeding.maxBPM.description
        let happinessSeedMax: String = "max_valence=" + seeding.maxHappiness.description
        let loudnessSeedMax: String = "max_loudness=" + seeding.maxLoudness.description
        let speechinessSeedMax: String = "max_speechiness=" + seeding.maxSpeechiness.description
        let acousticSeedMax: String = "max_acousticness=" + seeding.maxAcoustic.description
        
        let array = [danceSeedMax,energySeedMax,popularitySeedMax,tempoSeedMax,happinessSeedMax,loudnessSeedMax,speechinessSeedMax,acousticSeedMax,danceSeedMin,energySeedMin,popularitySeedMin,tempoSeedMin,happinessSeedMin,loudnessSeedMin,speechinessSeedMin,acousticSeedMin]
        
        return array.joined(separator: "&")
    }
    
}
