//
//  AMAlbumTest.swift
//  PumpyAnalyticsTests
//
//  Created by Jack Vanderpump on 19/09/2022.
//

import XCTest
@testable import PumpyAnalytics

final class AMAlbumTest: XCTestCase {
    
    let album = "1616728060"

    func testGateway() throws {
        let gateway = AlbumGateway()
        let promise = expectation(description: "Don't get error after call")
        var expectedResult: AMAlbumBoundary?
        var expectedCode: Int?
        
        gateway.get(id: album, authManager: AuthorisationManager()) { result, code in
            expectedResult = result
            expectedCode = code
            promise.fulfill()
        }
        wait(for: [promise], timeout: 3)
        
        XCTAssertEqual(expectedCode, 200)
        XCTAssertNotNil(expectedResult)
    }
    
    func testMockGateway() throws {
        let gateway = MockAlbumGateway()
        let promise = expectation(description: "Don't get error after call")
        var expectedResult: AMAlbumBoundary?
        var expectedCode: Int?

        gateway.get(id: album, authManager: AuthorisationManager()) { result, code in
            expectedResult = result
            expectedCode = code
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)

        XCTAssertEqual(expectedCode, 200)
        XCTAssertNotNil(expectedResult)
    }

    func testUseCase() throws {
        let useCase = GetAMAlbum(gateway: MockAlbumGateway())
        let promise = expectation(description: "Don't get error after call")
        var expectedResult: AMAlbum?

        useCase.execute(id: album, authManager: AuthorisationManager()) { album, error in
            expectedResult = album
            promise.fulfill()
        }
        wait(for: [promise], timeout: 1)

        XCTAssertNotNil(expectedResult)
        XCTAssertEqual("Swimming In The Stars - Single", expectedResult?.name)
        XCTAssertNotEqual(expectedResult?.tracks.count, 0)
    }

}
