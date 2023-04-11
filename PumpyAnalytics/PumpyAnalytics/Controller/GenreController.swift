//
//  GenreController.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 11/04/2023.
//

import Foundation

public class GenreController {
    
    public init() {}
    private let useCase = GetGenres()
    
    /// Retrieves a list of genres from Spotify endpoint
    /// Genres are in sentence case. e.g. "Pop"
    public func getGenres(authManager: AuthorisationManager, completion: @escaping (_ genres: [String]) -> ()) {
        useCase.execute(authManager: authManager, completion: completion)
    }
    
    /// Retrieved through Spotify developer portal 11/3/23 https://developer.spotify.com/documentation/web-api/reference/get-recommendation-genres
    ///  Genres are in sentence case.
    public static let defaultGenres: [String] = {
        ["acoustic", "afrobeat", "alt-rock", "alternative", "ambient", "anime", "black-metal", "bluegrass", "blues", "bossanova", "brazil", "breakbeat", "british", "cantopop", "chicago-house", "children", "chill", "classical", "club", "comedy", "country", "dance", "dancehall", "death-metal", "deep-house", "detroit-techno", "disco", "disney", "drum-and-bass", "dub", "dubstep", "edm", "electro", "electronic", "emo", "folk", "forro", "french", "funk", "garage", "german", "gospel", "goth", "grindcore", "groove", "grunge", "guitar", "happy", "hard-rock", "hardcore", "hardstyle", "heavy-metal", "hip-hop", "holidays", "honky-tonk", "house", "idm", "indian", "indie", "indie-pop", "industrial", "iranian", "j-dance", "j-idol", "j-pop", "j-rock", "jazz", "k-pop", "kids", "latin", "latino", "malay", "mandopop", "metal", "metal-misc", "metalcore", "minimal-techno", "movies", "mpb", "new-age", "new-release", "opera", "pagode", "party", "philippines-opm", "piano", "pop", "pop-film", "post-dubstep", "power-pop", "progressive-house", "psych-rock", "punk", "punk-rock", "r-n-b", "rainy-day", "reggae", "reggaeton", "road-trip", "rock", "rock-n-roll", "rockabilly", "romance", "sad", "salsa", "samba", "sertanejo", "show-tunes", "singer-songwriter", "ska", "sleep", "songwriter", "soul", "soundtracks", "spanish", "study", "summer", "swedish", "synth-pop", "tango", "techno", "trance", "trip-hop", "turkish", "work-out", "world-music"
        ].map { $0.capitalized}
    }()
    
}
