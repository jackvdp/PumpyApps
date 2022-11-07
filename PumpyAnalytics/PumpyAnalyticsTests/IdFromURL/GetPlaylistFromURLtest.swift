//
//  GeTPlaylistFromURLtest.swift
//  PumpyAnalyticsTests
//
//  Created by Jack Vanderpump on 02/08/2022.
//

import XCTest
@testable import PumpyAnalytics

class GetPlaylistFromURLtest: XCTestCase {

    let sybURL = "https://business.soundtrackyourbrand.com/discover/music/Q29sbGVjdGlvbiwsMWthZm9xbjZpMm8vU3lzdGVtLHN5c3RlbSwwLw.."
    let spotifyURL = "https://open.spotify.com/playlist/3ZgmfR6lsnCwdffZUan8EA"
    let appleMusicURL = "https://music.apple.com/gb/playlist/permanent-vacation/pl.9dc9de535a544d5d9692766feac0f7c7"
    let badURL = "pl.9dc9de535a544d5d9692766feac0f7c7"
    
    func testReturnsSYBPlaylist() {
        let useCase = GetIDFromURL()
        
        let (snapshot, error) = useCase.execute(sybURL)
        
        XCTAssertNotNil(snapshot)
        XCTAssertNil(error)
        XCTAssertEqual(snapshot?.type, .syb(id: "Q29sbGVjdGlvbiwsMWthZm9xbjZpMm8vU3lzdGVtLHN5c3RlbSwwLw.."))
    }
    
    func testReturnsSpotifyPlaylist() {
        let useCase = GetIDFromURL()
        
        let (snapshot, error) = useCase.execute(spotifyURL)
        
        XCTAssertNotNil(snapshot)
        XCTAssertNil(error)
        XCTAssertEqual(snapshot?.type, .spotify(id: "3ZgmfR6lsnCwdffZUan8EA"))
    }
    
    func testReturnsAMPlaylist() {
        let useCase = GetIDFromURL()
        
        let (snapshot, error) = useCase.execute(appleMusicURL)
        
        XCTAssertNotNil(snapshot)
        XCTAssertNil(error)
        XCTAssertEqual(snapshot?.type, .am(id: "pl.9dc9de535a544d5d9692766feac0f7c7"))
    }
    
    func testReturnsNil() {
        let useCase = GetIDFromURL()
        
        let (snapshot, error) = useCase.execute(badURL)
        
        XCTAssertNil(snapshot)
        XCTAssertNotNil(error)
    }

}
