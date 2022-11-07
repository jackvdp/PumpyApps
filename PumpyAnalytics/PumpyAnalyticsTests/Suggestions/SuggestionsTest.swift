//
//  SuggestionsTest.swift
//  PumpyAnalyticsTests
//
//  Created by Jack Vanderpump on 03/09/2022.
//

import Foundation
import XCTest
@testable import PumpyAnalytics

class GetSuggestionsTest: XCTestCase {
    
    func testUseCase() {
        let useCase = GetSuggestions()
        let jsonString = SuggestionsHelper.response
        var responseObject: Suggestions!

        do {
            let suggestions = try JSONDecoder().decode(Suggestions.self, from: Data(jsonString.utf8))
            responseObject = suggestions
        } catch {
            print("**** \(error)")
            XCTFail("Did not decode JSON")
            return
        }
        
        let (collection, error) = useCase.handleResponse(suggestions: responseObject, code: 200)
        
        XCTAssertNil(error)
        XCTAssertNotNil(collection)
        XCTAssertNotEqual(0, collection.count, "Didn't get any collection")
        XCTAssertNotEqual(0, collection.first?.items.count, "Didn't get all tracks")
    }
}
