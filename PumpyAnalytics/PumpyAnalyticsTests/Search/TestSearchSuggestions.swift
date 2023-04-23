//
//  TestSearchSuggestions.swift
//  PumpyAnalyticsTests
//
//  Created by Jack Vanderpump on 22/04/2023.
//

import XCTest
@testable import PumpyAnalytics

final class TestSearchSuggestions: XCTestCase {

    func testExample() throws {
        let promise = expectation(description: "Got suggestions")
        
        let controller = SearchController()
        let authManager = AuthorisationManager()
        
        controller.searchSuggestions(term: "Coldplay", authManager: authManager) { suggestions, error in
            XCTAssertNil(error)
            XCTAssert(!suggestions.isEmpty)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func testWithWeirdSymbols() throws {
        let promise = expectation(description: "Got suggestions")
        
        let controller = SearchController()
        let authManager = AuthorisationManager()
        
        controller.searchSuggestions(term: "Coldplay's", authManager: authManager) { suggestions, error in
            XCTAssertNil(error)
            XCTAssert(!suggestions.isEmpty)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func testWithJibberish() throws {
        let promise = expectation(description: "Got suggestions")
        
        let controller = SearchController()
        let authManager = AuthorisationManager()
        
        controller.searchSuggestions(term: "ednrejfnrejfre", authManager: authManager) { suggestions, error in
            XCTAssertNil(error)
            XCTAssert(!suggestions.isEmpty)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func testWithSpaces() throws {
        let promise = expectation(description: "Got suggestions")
        
        let controller = SearchController()
        let authManager = AuthorisationManager()
        
        controller.searchSuggestions(term: "refnren jfrenfrtjfn", authManager: authManager) { suggestions, error in
            XCTAssertNil(error)
            XCTAssert(!suggestions.isEmpty)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func testWithSpacesAndOddChars() throws {
        let promise = expectation(description: "Got suggestions")
        
        let controller = SearchController()
        let authManager = AuthorisationManager()
        
        controller.searchSuggestions(term: "refnren jfrenfrtjfn !!! '' jfrefnjrek @jdnf", authManager: authManager) { suggestions, error in
            XCTAssertNil(error)
            XCTAssert(!suggestions.isEmpty)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
    }

}
