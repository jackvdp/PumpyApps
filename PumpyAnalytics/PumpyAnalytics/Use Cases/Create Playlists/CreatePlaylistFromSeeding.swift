//
//  CreatePlaylistFromSeeding.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 19/06/2022.
//

import Foundation

class CreatePlaylistFromSeeding {
    
    let gateway = SpotifyRecommendPlaylistGateway()
    
    func execute(seeding: PlaylistSeeding,
                 authManager: AuthorisationManager,
                 completion: @escaping (RecommendedPlaylist?, ErrorMessage?) -> ()) {
        
        let query = constructQuery(seeding: seeding)
        
        gateway.run(query: query, authManager: authManager) { tracks, error in
            
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

    private func convertCustomSeeding(_ seeding: AttributeSeeding) -> String {
        let danceSeedMin: String? = seeding.minDanceability == nil ? nil : "min_danceability=" + seeding.minDanceability!.description
        let energySeedMin: String? = seeding.minEnergy == nil ? nil : "min_energy=" + seeding.minEnergy!.description
        let popularitySeedMin: String? = seeding.minPopularity == nil ? nil : "min_popularity=" + seeding.minPopularity!.description
        let tempoSeedMin: String? = seeding.minBPM == nil ? nil : "min_tempo=" + seeding.minBPM!.description
        let happinessSeedMin: String? = seeding.minHappiness == nil ? nil : "min_valence=" + seeding.minHappiness!.description
        let loudnessSeedMin: String? = seeding.minLoudness == nil ? nil : "min_loudness=" + seeding.minLoudness!.description
        let speechinessSeedMin: String? = seeding.minSpeechiness == nil ? nil : "min_speechiness=" + seeding.minSpeechiness!.description
        let acousticSeedMin: String? = seeding.minAcoustic == nil ? nil : "min_acousticness=" + seeding.minAcoustic!.description

        let danceSeedMax: String? = seeding.maxDanceability == nil ? nil : "max_danceability=" + seeding.maxDanceability!.description
        let energySeedMax: String? = seeding.maxEnergy == nil ? nil : "max_energy=" + seeding.maxEnergy!.description
        let popularitySeedMax: String? = seeding.maxPopularity == nil ? nil : "max_popularity=" + seeding.maxPopularity!.description
        let tempoSeedMax: String? = seeding.maxBPM == nil ? nil : "max_tempo=" + seeding.maxBPM!.description
        let happinessSeedMax: String? = seeding.maxDanceability == nil ? nil : "max_valence=" + seeding.maxHappiness!.description
        let loudnessSeedMax: String? = seeding.maxLoudness == nil ? nil : "max_loudness=" + seeding.maxLoudness!.description
        let speechinessSeedMax: String? = seeding.maxSpeechiness == nil ? nil : "max_speechiness=" + seeding.maxSpeechiness!.description
        let acousticSeedMax: String? = seeding.maxAcoustic == nil ? nil : "max_acousticness=" + seeding.maxAcoustic!.description

        let array = [danceSeedMax,energySeedMax,popularitySeedMax,tempoSeedMax,happinessSeedMax,loudnessSeedMax,speechinessSeedMax,acousticSeedMax,danceSeedMin,energySeedMin,popularitySeedMin,tempoSeedMin,happinessSeedMin,loudnessSeedMin,speechinessSeedMin,acousticSeedMin]

        let compactArray = array.compactMap { $0 }
        
        return compactArray.joined(separator: "&")
    }
    
}
