//
//  SearchAMTracksTest.swift
//  PumpyAnalyticsTests
//
//  Created by Jack Vanderpump on 15/09/2022.
//

import XCTest
@testable import PumpyAnalytics

final class SearchAMTracksTest: XCTestCase {
    
    let term = "Ed Sheeran"

    func testGateway() throws {
        let gateway = SearchTracksGateway()
        let promise = expectation(description: "Don't get error after call")
        var expectedResult: SongSearchResults?
        
        gateway.run(term, limit: 10, authManager: AuthorisationManager()) { result, code in
            expectedResult = result
            promise.fulfill()
        }
        wait(for: [promise], timeout: 3)
        
        XCTAssertNotNil(expectedResult)
    }
    
    func testMockGateway() throws {
        let gateway = MockSearchTracksGateway()
        let promise = expectation(description: "Don't get error after call")
        var expectedResult: SongSearchResults?
        
        gateway.run(term, limit: 10, authManager: AuthorisationManager()) { result, code in
            expectedResult = result
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        
        XCTAssertNotNil(expectedResult)
    }
    
    func testUseCase() throws {
        let useCase = SearchAMTracks(gateway: MockSearchTracksGateway())
        let promise = expectation(description: "Don't get error after call")
        var expectedResult: [Track]?
        
        useCase.execute(term: term, limit: 10, authManager: AuthorisationManager()) { songs, error in
            expectedResult = songs
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        
        XCTAssertNotNil(expectedResult)
        XCTAssertEqual("My G", expectedResult?.first?.title)
    }
    
    func testController() throws {
        let controller = SearchController()
        let promise = expectation(description: "Don't get error after call")
        var expectedResult: [Track]?
//        controller.searchAMTracksUseCase.gateway = MockSearchTracksGateway()
        
        controller.searchAMTracks(term, authManager: AuthorisationManager()) { songs, error in
            expectedResult = songs
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        
        XCTAssertNotNil(expectedResult)
        XCTAssertEqual("My G", expectedResult?.first?.title)
    }

}
