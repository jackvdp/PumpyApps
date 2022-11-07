//
//  GetRecommended.swift
//  PumpyAnalyticsTests
//
//  Created by Jack Vanderpump on 20/06/2022.
//

import XCTest
import SwiftyJSON
@testable import PumpyAnalytics

class GetRecommendedPlaylistTest: XCTestCase {

    func testParseForTracks() {
        
        let parser = SpotifyTracksParser()
        let json = JSON.init(parseJSON: RecommendationsHelpers.tracks)
        
        let tracks = parser.parseForTracks(tracks: json, authManager: AuthorisationManager())
        
        XCTAssertNotEqual([], tracks, "Not able to parse for tracks")
        
    }
    
    func testGateway20() {
        let promise = expectation(description: "Don't get error after call")
        let gateway = SpotifyTracksGateway()
        let authManager = AuthorisationManager()
        var expectedTracks = [Track]()
        var timer: Timer?
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if authManager.spotifyToken != nil {
                timer?.invalidate()
                gateway.run(trackIDs: RecommendationsHelpers.tracksToRecieve20,
                            authManager: authManager) { tracks, error in
                    
                    if error != nil {
                        print(error ?? "")
                        XCTFail()
                    }
                    
                    expectedTracks = tracks
                    promise.fulfill()
                    
                }
            }
        })
        wait(for: [promise], timeout: 3)
        
        XCTAssertNotEqual([], expectedTracks, "Tracks is empty")
    }
    
    func testGateway30() {
        let promise = expectation(description: "Don't get error after call")
        let gateway = SpotifyTracksGateway()
        let authManager = AuthorisationManager()
        var expectedTracks = [Track]()
        var timer: Timer?
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if authManager.spotifyToken != nil {
                timer?.invalidate()
                gateway.run(trackIDs: RecommendationsHelpers.tracksToRecieve30,
                            authManager: authManager) { tracks, error in
                    
                    if error != nil {
                        print(error ?? "")
                        XCTFail()
                    }
                    
                    expectedTracks = tracks
                    promise.fulfill()
                    
                }
            }
        })
        wait(for: [promise], timeout: 3)
        
        XCTAssertNotEqual([], expectedTracks, "Tracks is empty")
    }
    
    func testGateway40() {
        let promise = expectation(description: "Don't get error after call")
        let gateway = SpotifyTracksGateway()
        let authManager = AuthorisationManager()
        var expectedTracks = [Track]()
        var timer: Timer?
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if authManager.spotifyToken != nil {
                timer?.invalidate()
                gateway.run(trackIDs: RecommendationsHelpers.tracksToRecieve40,
                            authManager: authManager) { tracks, error in
                    
                    if error != nil {
                        print(error ?? "")
                        XCTFail()
                    }
                    
                    expectedTracks = tracks
                    promise.fulfill()
                    
                }
            }
        })
        wait(for: [promise], timeout: 3)
        
        XCTAssertNotEqual([], expectedTracks, "Tracks is empty")
    }
    
    func testGateway50() {
        let promise = expectation(description: "Don't get error after call")
        let gateway = SpotifyTracksGateway()
        let authManager = AuthorisationManager()
        var expectedTracks = [Track]()
        var timer: Timer?
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if authManager.spotifyToken != nil {
                timer?.invalidate()
                gateway.run(trackIDs: RecommendationsHelpers.tracksToRecieve50,
                            authManager: authManager) { tracks, error in
                    
                    if error != nil {
                        print(error ?? "")
                        XCTFail()
                    }
                    
                    expectedTracks = tracks
                    promise.fulfill()
                    
                }
            }
        })
        wait(for: [promise], timeout: 3)
        
        XCTAssertNotEqual([], expectedTracks, "Tracks is empty")
    }
    
    func testUseCase() {
        let promise = expectation(description: "Don't get error after call")
        let useCase = GetRecommendedPlaylist()
        let authManager = AuthorisationManager()
        var expectedPlaylist: RecommendedPlaylist?
        var timer1: Timer?
        
        timer1 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if authManager.spotifyToken != nil {
                timer1?.invalidate()
                useCase.execute(snapshot: MockData.snapshot,
                                trackIDs: RecommendationsHelpers.tracksToRecieve20,
                                authManager: authManager) { playlist, error in
                    
                    if error != nil {
                        print(error ?? "")
                        XCTFail()
                    }
                    
                    expectedPlaylist = playlist
                    promise.fulfill()
                }
            }
        })
        wait(for: [promise], timeout: 5)
        
        XCTAssertNotNil(expectedPlaylist)
        XCTAssertNotEqual(0, expectedPlaylist?.tracks.count, "Didn't get all tracks")
        XCTAssertNotEqual([], expectedPlaylist?.tracks, "Didn't get all tracks")
    }
    
    func testUseCase50() {
        let promise = expectation(description: "Don't get error after call")
        let useCase = GetRecommendedPlaylist()
        let authManager = AuthorisationManager()
        var expectedPlaylist: RecommendedPlaylist?
        var timer1: Timer?
        
        timer1 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if authManager.spotifyToken != nil {
                timer1?.invalidate()
                useCase.execute(snapshot: MockData.snapshot,
                                trackIDs: RecommendationsHelpers.tracksToRecieve50,
                                authManager: authManager) { playlist, error in
                    
                    if error != nil {
                        print(error ?? "")
                        XCTFail()
                    }
                    
                    expectedPlaylist = playlist
                    promise.fulfill()
                }
            }
        })
        wait(for: [promise], timeout: 5)
        
        XCTAssertNotNil(expectedPlaylist)
        XCTAssertNotEqual(0, expectedPlaylist?.tracks.count, "Didn't get all tracks")
        XCTAssertNotEqual([], expectedPlaylist?.tracks, "Didn't get all tracks")
    }
    
    func testUseCaseWithMoreThan50() {
        let promise = expectation(description: "Don't get error after call")
        let useCase = GetRecommendedPlaylist()
        let authManager = AuthorisationManager()
        var expectedPlaylist: RecommendedPlaylist?
        var timer1: Timer?
        
        timer1 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if authManager.spotifyToken != nil {
                timer1?.invalidate()
                useCase.execute(snapshot: MockData.snapshot,
                                trackIDs: RecommendationsHelpers.tracksToRecieve150,
                                authManager: authManager) { playlist, error in
                    
                    if error != nil {
                        print(error ?? "")
                        XCTFail()
                    }
                    
                    expectedPlaylist = playlist
                    promise.fulfill()
                }
            }
        })
        wait(for: [promise], timeout: 5)
        
        XCTAssertNotNil(expectedPlaylist)
        XCTAssertNotEqual(0, expectedPlaylist?.tracks.count, "Didn't get all tracks")
        XCTAssertNotEqual([], expectedPlaylist?.tracks, "Didn't get all tracks")
    }
    
    func testControllerWithMoreThan50() {
        let promise = expectation(description: "Don't get error after call")
        let controller = PlaylistController()
        let authManager = AuthorisationManager()
        var expectedPlaylist: Playlist?
        var timer1: Timer?
        
        timer1 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if authManager.spotifyToken != nil {
                timer1?.invalidate()
                
                controller.get(libraryPlaylist: PlaylistSnapshot(name: "Test",
                                                                         sourceID: UUID().uuidString,
                                                                         type: .recommended(RecommendationsHelpers.tracksToRecieve150)),
                                       authManager: authManager) { playlist, error in
                    
                    if error != nil {
                        print(error ?? "")
                        XCTFail()
                    }
                    
                    expectedPlaylist = playlist
                    promise.fulfill()
                }
            }
        })
        wait(for: [promise], timeout: 5)
        
        
        XCTAssertNotNil(expectedPlaylist)
        XCTAssertEqual(150, expectedPlaylist?.tracks.count, "Didn't get all tracks")
    }
    
}
