//
//  BookmarkedTests.swift
//  PumpyLibraryTests
//
//  Created by Jack Vanderpump on 03/08/2023.
//

import XCTest
@testable import PumpyLibrary
import PumpyAnalytics

final class BookmarkedTests: XCTestCase {

    func testSuccessfulDecodingAndEncoding() throws {
        let array: [BookmarkedItem] = [
            .playlist(PumpyAnalytics.MockData.snapshot),
            .track(CodableTrack(title: "Test", artist: "Test", isExplicit: true, artworkURL: "www.google.com", playbackID: "xxxx")),
            .track(CodableTrack(title: "Test2", artist: "Test2", isExplicit: false, artworkURL: "www.google.com", playbackID: "yyyy")),
        ]
        
        let data = try JSONEncoder().encode(array)
        let model = try JSONDecoder().decode([BookmarkedItem].self, from: data)
        
        if case let .playlist(snapshot) = model.first {
            XCTAssert(snapshot.sourceID == PumpyAnalytics.MockData.snapshot.sourceID)
        } else {
            XCTFail()
        }
    }

}
