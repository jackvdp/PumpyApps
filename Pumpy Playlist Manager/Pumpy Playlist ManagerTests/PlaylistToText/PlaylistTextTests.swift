//
//  Pumpy_Playlist_ManagerTests.swift
//  Pumpy Playlist ManagerTests
//
//  Created by Jack Vanderpump on 30/10/2022.
//

import XCTest
@testable import Pumpy_Playlist_Manager
import PumpyAnalytics

final class PlaylistTextTests: XCTestCase {

    func testConvertTextToTrackTexts() throws {
        let viewModel = TextToPlaylistViewModel()
        let mockText = PlaylistTextHelper().mock
        
        let trackTexts = viewModel.seperateBulkTextIntoTrackText(mockText)
        
        XCTAssertEqual("Dancing in the street - Martha Reeves and the Vandellas", trackTexts.first)
        XCTAssertEqual(trackTexts.count, 137)
    }
    
    func testArrangeDictionaryInPrepForFetch() throws {
        let viewModel = TextToPlaylistViewModel()
        let mockText = PlaylistTextHelper().smallMock
        let objectToRemove = ("objectToRemove", MockData.track)
        let objectToKeep = ("Dancing in the street - Martha Reeves and the Vandellas", MockData.track)
        viewModel.tracksDictionary.append(objectToRemove)
        viewModel.tracksDictionary.append(objectToKeep)
        
        let trackTexts = viewModel.seperateBulkTextIntoTrackText(mockText)
        let tracksToFetch = viewModel.prepareDictionaryAndReturnTracksToGet(trackTexts)
        
        XCTAssertEqual(viewModel.tracksDictionary.count, 3)
        XCTAssertEqual(tracksToFetch.count, 2)
        XCTAssertNil(viewModel.tracksDictionary.filter { $0 == objectToRemove}.first)
        XCTAssertNotNil(viewModel.tracksDictionary.filter { $0 == objectToKeep}.first)
    }
    
    func testEditOneValueRetainOrder() throws {
        let viewModel = TextToPlaylistViewModel()
        
        let mockText = PlaylistTextHelper().smallMock
        let trackTexts = viewModel.seperateBulkTextIntoTrackText(mockText)
        let _ = viewModel.prepareDictionaryAndReturnTracksToGet(trackTexts)
        
        XCTAssertEqual("Do you love me - the contours", viewModel.tracksDictionary[1].0)
        
        let newMockText = PlaylistTextHelper().smallMockAfterEdit
        let newTrackTexts = viewModel.seperateBulkTextIntoTrackText(newMockText)
        let _ = viewModel.prepareDictionaryAndReturnTracksToGet(newTrackTexts)
        
        XCTAssertEqual("Do you love me", viewModel.tracksDictionary[1].0)
    }
    
    func testFetchOnlyIncludesOneTrackAfterEdit() throws {
        let viewModel = TextToPlaylistViewModel()
        let mockText = PlaylistTextHelper().mock
        let trackTexts = viewModel.seperateBulkTextIntoTrackText(mockText)
        let tracksToFetch = viewModel.prepareDictionaryAndReturnTracksToGet(trackTexts)
        
        XCTAssertEqual(tracksToFetch.count, 137)
        
        let newMockText = PlaylistTextHelper().mockAfterEdit
        let newTrackTexts = viewModel.seperateBulkTextIntoTrackText(newMockText)
        let newTracksToFetch = viewModel.prepareDictionaryAndReturnTracksToGet(newTrackTexts)
        
        XCTAssertEqual(newTracksToFetch.count, 1)
    }

}


