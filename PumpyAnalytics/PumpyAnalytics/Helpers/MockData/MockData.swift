//
//  MockData.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/02/2022.
//

import Foundation

public struct MockData {
    
    public static let track = Track(title: "Numb",
                                 artist: "Pink Floyd",
                                 album: "Dark Side of the Moon",
                                 isrc: "SJHFJTUBEGKYL846",
                                 artworkURL: "",
                                    previewUrl: "",
                                    isExplicit: true,
                                 sourceID: "",
                                 authManager: AuthorisationManager(),
                                 appleMusicItem: AppleMusicItem(
                                    isrc: "SJHFJTUBEGKYL846",
                                    id: "",
                                    name: "Numb",
                                    artistName: "Pink Floyd",
                                    artworkURL: "", genres: ["Pop", "Rock"],
                                    type: .track),
                                 spotifyItem: SpotifyItem(
                                    isrc: "SJHFJTUBEGKYL846",
                                    id: "",
                                    year: 2002,
                                    popularity: 75)
    )
    
    public static let secondTrack = Track(title: "Hotel California",
                                 artist: "The Eagles",
                                 album: "Hell Frozen Over",
                                 isrc: "SJHFJTUBEGKYL846",
                                 artworkURL: "",
                                          previewUrl: "",
                                          isExplicit: true,
                                 sourceID: "",
                                 authManager: AuthorisationManager(),
                                 appleMusicItem: AppleMusicItem(
                                    isrc: "SJHFJTUBEGKYL846",
                                    id: "",
                                    name: "Hotel California",
                                    artistName: "The Eagles",
                                    artworkURL: "", genres: ["Pop", "Rock", "Soul", "Indie"],
                                    type: .track),
                                 spotifyItem: SpotifyItem(
                                    isrc: "SJHFJTUBEGKYL846",
                                    id: "",
                                    year: 1982,
                                    popularity: 99)
    )
    
    public static let thirdTrack = Track(title: "Hotel California",
                                 artist: "The Eagles",
                                 album: "Hell Frozen Over",
                                 isrc: "SJHFJTUBEGKYL846",
                                 artworkURL: "",
                                         previewUrl: "",
                                         isExplicit: true,
                                 sourceID: "",
                                 authManager: AuthorisationManager(),
                                 appleMusicItem: AppleMusicItem(
                                    isrc: "SJHFJTUBEGKYL846",
                                    id: "",
                                    name: "Hotel California",
                                    artistName: "The Eagles",
                                    artworkURL: "", genres: ["Pop", "Rock", "Soul", "Indie"],
                                    type: .track),
                                 spotifyItem: SpotifyItem(
                                    isrc: "SJHFJTUBEGKYL846",
                                    id: "",
                                    year: 1982,
                                    popularity: 99)
    )
    
    public static var trackWithLongDetails: Track {
        var trk = Track(title: "Really really really really really long name",
                        artist: "Really really really really really long name",
                        album: "Dark Side of the Moon",
                        isrc: "SJHFJTUBEGKYL846",
                        artworkURL: "",
                           previewUrl: "",
                           isExplicit: true,
                        sourceID: "",
                        authManager: AuthorisationManager(),
                        appleMusicItem: AppleMusicItem(
                           isrc: "SJHFJTUBEGKYL846",
                           id: "",
                           name: "Numb",
                           artistName: "Pink Floyd",
                           artworkURL: "", genres: ["Pop", "Rock", "Really really long genre name", "Loads of genres", "Jazzy Blues"],
                           type: .track),
                        spotifyItem: SpotifyItem(
                           isrc: "SJHFJTUBEGKYL846",
                           id: "",
                           year: 2002,
                           popularity: 75))
        trk.audioFeatures = AudioFeatures(danceability: 0.95,
                                            energy: 0.8,
                                            key: 1,
                                            loudness: 100,
                                            tempo: 130,
                                            valence: 0.9,
                                            liveliness: 0.9,
                                            instrumentalness: 0.9,
                                            speechiness: 0.9,
                                            acousticness: 0.9,
                                            id: track.sourceID)
        return trk
    }
    
    public static var trackWithFeatures: Track {
        track.audioFeatures = AudioFeatures(danceability: 0.95,
                                            energy: 0.8,
                                            key: 1,
                                            loudness: 100,
                                            tempo: 130,
                                            valence: 0.9,
                                            liveliness: 0.9,
                                            instrumentalness: 0.9,
                                            speechiness: 0.9,
                                            acousticness: 0.9,
                                            id: track.sourceID)
        return track
    }
    
    public static var secondTrackWithFeatures: Track {
        secondTrack.audioFeatures = AudioFeatures(danceability: 0.8,
                                            energy: 0.73,
                                            key: 1,
                                            loudness: -16,
                                            tempo: 92,
                                            valence: 0.87,
                                            liveliness: 0.86,
                                            instrumentalness: 0.52,
                                                  speechiness: 0.78,
                                            acousticness: 0.13,
                                            id: track.sourceID)
        return secondTrack
    }
    
    public static let tracks = [Track](repeating: track, count: 200)
    
    public static let playlist = SYBPlaylist(name: "Test",
                                             curator: "SoundTrackYourBrand",
                                          tracks: tracks,
                                          artworkURL: nil,
                                          description: "Romantic and elegant jazz for two. A table not too close to the orchestra.",
                                          shortDescription: "Romantic and elegant jazz for two. A table not too close to the orchestra.",
                                          sybID: "rgvvtt",
                                          authManager: AuthorisationManager())
    
    public static let customPlaylist = CustomPlaylist(name: "Test",
                                                      curator: "Custom",
                                                          tracks: tracks,
                                                          artworkURL: nil,
                                                          description: nil,
                                                          shortDescription: nil,
                                                          logic: CustomPlaylistLogic(snapshots: [MockData.snapshot],
                                                                                     index: 0,
                                                                                     divideBy: DivideBy.one,
                                                                                     sortBy: SortTracks.bpm),
                                                          authManager: AuthorisationManager(), sourceID: "vjnkgtrnjkgtr")
    
    public static let snapshot = PlaylistSnapshot(name: "Test",
                                                             shortDescription: "Romantic and elegant jazz for two. A table not too close to the orchestra.",
                                                             sourceID: "jvnrfklrtfnlk",
                                                             type: .syb(id: "njrnjr"))
    
    public static let snapshots = [PlaylistSnapshot](repeating: snapshot, count: 10)
    
    public static let item = SuggestedItem(name: "A Bit of Lunch",
                                           id: "jcrefr",
                                           type: .playlists,
                                           artworkURL: "",
                                           curator: "Pumpy Music")
    
    public static let items = Array(repeating: item, count: 20)
    
    public static let collection = SuggestedCollection(title: "Your recommended", items: items, types: [.playlists])
    
    public static let collectionWithOneItem = SuggestedCollection(title: "Your recommended", items: [item], types: [.playlists])
    
    public static let albumCollection = SuggestedCollection(title: "Your recommended", items: items, types: [.albums])

}
