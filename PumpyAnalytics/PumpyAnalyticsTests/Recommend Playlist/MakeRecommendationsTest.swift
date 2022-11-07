//
//  PumpyAnalyticsTests.swift
//  PumpyAnalyticsTests
//
//  Created by Jack Vanderpump on 19/06/2022.
//

import XCTest
@testable import PumpyAnalytics
import SwiftyJSON
import SwiftUI

class MakeRecommendationsTest: XCTestCase {
    let authManager = AuthorisationManager()
    
    func testParseForRecommendations() {
        // Arrange
        let parser = SpotifyTracksParser()
        let json = JSON.init(parseJSON: RecommendationsHelpers.createResult)
        
        // Act
        let tracks = parser.parseForTracks(tracks: json, authManager: AuthorisationManager())
        
        // Assert
        XCTAssertNotEqual([], tracks, "Not able to parse for recommendations")
        XCTAssertEqual(20, tracks.count, "Did not recieved 20 tracks: got \(tracks.count) instead")
    }
    
//    func testForQueryConstructor() {
//        
//        let useCase = CreatePlaylistFromSeeding()
//        let seeding = PlaylistSeeding(trackIDs: ["0PNXSsQJi5a0pfsvi7ySKK",
//                                                 "0PNXSsQJi5a0pfsvi7ySKK",
//                                                 "0PNXSsQJi5a0pfsvi7ySKK",
//                                                 "0PNXSsQJi5a0pfsvi7ySKK"],
//                                      artistIDs: ["3TVXtAsR1Inumwj472S9r4", "3TVXtAsR1Inumwj472S9r4"],
//                                      genres: ["pop"],
//                                      playlistSize: 100,
//                                      seeding: .average(AverageSeeding(targetDanceability: 0.8,
//                                                                       targetEnergy: 0.8,
//                                                                       targetPopularity: 80,
//                                                                       targetBPM: 80,
//                                                                       targetHappiness: 0.8,
//                                                                       targetLoudness: -8,
//                                                                       targetSpeechiness: 0.8,
//                                                                       targetAcoustic: 0.8)))
//        
//        let queryCreated = useCase.constructQuery(seeding: seeding)
//        
//        XCTAssertEqual(queryCreated, RecommendationsHelpers.query, "Did not construct the correct query")
//    }
//    
//    func testForQueryConstructorWithSpace() {
//        
//        let useCase = CreatePlaylistFromSeeding()
//        let seeding = PlaylistSeeding(trackIDs: ["0PNXSsQJi5a0pfsvi7ySKK"],
//                                      artistIDs: ["3TVXtAsR1Inumwj472S9r4"],
//                                      genres: ["Pop Rock"],
//                                      playlistSize: 100,
//                                      seeding: .average(AverageSeeding(targetDanceability: 0.8,
//                                                                       targetEnergy: 0.8,
//                                                                       targetPopularity: 80,
//                                                                       targetBPM: 80,
//                                                                       targetHappiness: 0.8,
//                                                                       targetLoudness: -8,
//                                                                       targetSpeechiness: 0.8,
//                                                                       targetAcoustic: 0.8)))
//        
//        let queryCreated = useCase.constructQuery(seeding: seeding)
//        
//        XCTAssertEqual(queryCreated, RecommendationsHelpers.queryWithSpace, "Did not construct the correct query")
//    }
//    
//    func testAPICall() {
//        let promise = expectation(description: "Don't get error after call")
//        
//        let delay = authManager.spotifyToken == nil ? 1 : 0
//            
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
//            SpotifyRecommendPlaylistGateway().run(query: RecommendationsHelpers.query,
//                                           authManager: self.authManager) { tracks, error in
//
//                XCTAssertNil(error)
//                promise.fulfill()
//            }
//        }
//        
//        wait(for: [promise], timeout: 3)
//    }
//    
//    func testController() {
//        let promise = expectation(description: "Don't get error after call")
//        let delay = authManager.spotifyToken == nil ? 1 : 0
//        let seeding = PlaylistSeeding(trackIDs: ["0PNXSsQJi5a0pfsvi7ySKK",
//                                                 "0PNXSsQJi5a0pfsvi7ySKK",
//                                                 "0PNXSsQJi5a0pfsvi7ySKK",
//                                                 "0PNXSsQJi5a0pfsvi7ySKK"],
//                                      artistIDs: ["3TVXtAsR1Inumwj472S9r4", "3TVXtAsR1Inumwj472S9r4"],
//                                      genres: ["pop"],
//                                      playlistSize: 100,
//                                      seeding: .average(AverageSeeding(targetDanceability: 0.8,
//                                                                       targetEnergy: 0.8,
//                                                                       targetPopularity: 80,
//                                                                       targetBPM: 80,
//                                                                       targetHappiness: 0.8,
//                                                                       targetLoudness: -8,
//                                                                       targetSpeechiness: 0.8,
//                                                                       targetAcoustic: 0.8)))
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
//            PlaylistController().createPlaylistFromSuggestions(seeding: seeding,
//                                                               authManager: self.authManager) { playlist, error in
//                XCTAssertNil(error)
//                promise.fulfill()
//            }
//        }
//        
//        wait(for: [promise], timeout: 3)
//    }
}
