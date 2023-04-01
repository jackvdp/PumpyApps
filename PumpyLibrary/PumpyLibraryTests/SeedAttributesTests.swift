//
//  SeedAttributes.swift
//  PumpyLibraryTests
//
//  Created by Jack Vanderpump on 25/03/2023.
//

import XCTest
@testable import PumpyLibrary
@testable import PumpyAnalytics

final class SeedAttributesTest: XCTestCase {

    func testSetAverage() throws {
        let attributes = SeedAttributes.defaultAttributes()
        let popularity = attributes[0]
        let energy = attributes[1]
        let tempo = attributes[3]
        
        popularity.setAverage(tracks: Mock.trackWithSameFeatures)
        energy.setAverage(tracks: Mock.trackWithSameFeatures)
        tempo.setAverage(tracks: Mock.trackWithSameFeatures)
        
        XCTAssertEqual(0.8, energy.averageValue)
        XCTAssertEqual(120, tempo.averageValue)
        XCTAssertEqual(80, popularity.averageValue)
        
        XCTAssertEqual(0.55, energy.actualLower)
        XCTAssertEqual(90, tempo.actualLower)
        XCTAssertEqual(55, popularity.actualLower)
        
        XCTAssertEqual(1, energy.actualHigher)
        XCTAssertEqual(150, tempo.actualHigher)
        XCTAssertEqual(100, popularity.actualHigher)
    }
}

fileprivate struct Mock {
    
    static var trackWithSameFeatures: [PumpyAnalytics.Track] {
        tracks.forEach { track in
            track.audioFeatures = AudioFeatures(
                danceability: 0.8,
                energy: 0.8,
                key: nil,
                loudness: 0.8,
                tempo: 120,
                valence: 0.8,
                liveliness: 0.8,
                instrumentalness: 0.8,
                speechiness: 0.8,
                acousticness: 0.8,
                id: nil)
            track.spotifyItem = SpotifyItem(isrc: "",
                                            id: "",
                                            year: nil,
                                            popularity: 80)
        }
        return tracks
    }
    
    private static var tracks: [PumpyAnalytics.Track] = Array(repeating: track, count: 5)
    
    private static var track: PumpyAnalytics.Track = .init(
        title: "",
        artist: "",
        album: "",
        isrc: "",
        artworkURL: nil,
        previewUrl: nil,
        isExplicit: false,
        sourceID: "",
        authManager: AuthorisationManager()
    )
}
