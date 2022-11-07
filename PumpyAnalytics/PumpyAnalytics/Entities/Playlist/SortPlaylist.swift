//
//  SortPlaylist.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 01/03/2022.
//

import Foundation

public enum SortTracks: String, CaseIterable, Identifiable, Codable {
    case standard = "Playlist"
    case title = "Title"
    case artist = "Artist"
    case bpm = "BPM"
    case peak = "Peakness"
    case dance = "Danceability"
    case energy = "Energy"
    case happiness = "Happiness"
    case loudness = "Loudness"
    case instrumentalness = "Instrumentalness"
    case acousticness = "Acousticness"
    case liveliness = "Liveliness"
    case popularity = "Popularity"
    case genre = "Genre"
    case year = "Year"
    case explicit = "Explicit"
    
    public var id: Self { self }
}

public class SortPlaylistModel {
    
    let sortBy: SortTracks
    let tracks: [Track]
    let ascending: Bool
    
    public init(sortBy: SortTracks, tracks: [Track], ascending: Bool) {
        self.sortBy = sortBy
        self.tracks = tracks
        self.ascending = ascending
    }
    
    public func sortTracks() -> [Track] {
        var sortedTracks: [Track] { switch sortBy {
        case .standard:
            return tracks
        case .title:
            return tracks.sorted(by: {
                if $0.title == $1.title {
                    return $0.artist < $1.artist
                } else {
                    return $0.title < $1.title
                }
            } )
        case .artist:
            return tracks.sorted(by: {
                if $0.artist == $1.artist {
                    return $0.title < $1.title
                } else {
                    return $0.artist < $1.artist
                }
            } )
        case .bpm:
            return tracks.sorted(by: {
                if $0.audioFeatures?.tempo == $1.audioFeatures?.tempo {
                    return $0.artist < $1.artist
                } else {
                    return $0.audioFeatures?.tempo ?? 0 > $1.audioFeatures?.tempo ?? 0
                }
            } )
        case .dance:
            return tracks.sorted(by: {
                if $0.audioFeatures?.danceability == $1.audioFeatures?.danceability {
                    return $0.artist < $1.artist
                } else {
                    return $0.audioFeatures?.danceability ?? 0 > $1.audioFeatures?.danceability ?? 0
                }
            } )
        case .energy:
            return tracks.sorted(by: {
                if $0.audioFeatures?.energy == $1.audioFeatures?.energy {
                    return $0.artist < $1.artist
                } else {
                    return $0.audioFeatures?.energy ?? 0 > $1.audioFeatures?.energy ?? 0
                }
            } )
        case .peak:
            return tracks.sorted(by: {
                if $0.audioFeatures?.pumpyScore == $1.audioFeatures?.pumpyScore {
                    return $0.artist < $1.artist
                } else {
                    return $0.audioFeatures?.pumpyScore ?? 0 > $1.audioFeatures?.pumpyScore ?? 0
                }
            })
        case .popularity:
            return tracks.sorted(by: {
                if $0.spotifyItem?.popularity == $1.spotifyItem?.popularity {
                    return $0.artist < $1.artist
                } else {
                    return $0.spotifyItem?.popularity ?? 0 > $1.spotifyItem?.popularity ??  0
                }
            })
        case .year:
            return tracks.sorted(by: {
                if $0.spotifyItem?.year == $1.spotifyItem?.year {
                    return $0.artist < $1.artist
                } else {
                    return $0.spotifyItem?.year ?? 0 > $1.spotifyItem?.year ?? 0
                }
            })
        case .loudness:
            return tracks.sorted(by: {
                if $0.audioFeatures?.loudness == $1.audioFeatures?.loudness {
                    return $0.artist < $1.artist
                } else {
                    return $0.audioFeatures?.loudness ?? 0 > $1.audioFeatures?.loudness ?? 0
                }
            } )
        case .liveliness:
            return tracks.sorted(by: {
                if $0.audioFeatures?.liveliness == $1.audioFeatures?.liveliness {
                    return $0.artist < $1.artist
                } else {
                    return $0.audioFeatures?.liveliness ?? 0 > $1.audioFeatures?.liveliness ?? 0
                }
            } )
        case .happiness:
            return tracks.sorted(by: {
                if $0.audioFeatures?.valence == $1.audioFeatures?.valence {
                    return $0.artist < $1.artist
                } else {
                    return $0.audioFeatures?.valence ?? 0 > $1.audioFeatures?.valence ?? 0
                }
            } )
        case .instrumentalness:
            return tracks.sorted(by: {
                if $0.audioFeatures?.instrumentalness == $1.audioFeatures?.instrumentalness {
                    return $0.artist < $1.artist
                } else {
                    return $0.audioFeatures?.instrumentalness ?? 0 > $1.audioFeatures?.instrumentalness ?? 0
                }
            } )
        case .acousticness:
            return tracks.sorted(by: {
                if $0.audioFeatures?.acousticness == $1.audioFeatures?.acousticness {
                    return $0.artist < $1.artist
                } else {
                    return $0.audioFeatures?.acousticness ?? 0 > $1.audioFeatures?.acousticness ?? 0
                }
            } )
        case .genre:
            return tracks.sorted(by: {
                if $0.appleMusicItem?.genres.first == $1.appleMusicItem?.genres.first {
                    return $0.artist < $1.artist
                } else {
                    return $0.appleMusicItem?.genres.first ?? "ZZ" < $1.appleMusicItem?.genres.first ?? "ZZ"
                }
            } )
        case .explicit:
            return tracks.sorted(by: {
                if $0.isExplicit == $1.isExplicit {
                    return $0.artist < $1.artist
                } else {
                    return $0.isExplicit
                }
            } )
        }}
        
        return ascending ? sortedTracks.reversed() : sortedTracks
    }
    
}
