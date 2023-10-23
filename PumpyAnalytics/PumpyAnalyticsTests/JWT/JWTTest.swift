//
//  JWTTest.swift
//  PumpyAnalyticsTests
//
//  Created by Jack Vanderpump on 22/10/2023.
//

import XCTest
@testable import PumpyAnalytics

final class JWTTest: XCTestCase {

    func testvalidToken() throws {
        let token = "eyJhbGciOiJFUzI1NiIsImtpZCI6Ik1ZREM1NFBDWjkiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJBNEQ0REtBUEhOIiwiZXhwIjoxNzEzNzI3MDI5LCJpYXQiOjE2OTgwMDIyMjl9.fU2CtW1i1CVnN2xi9cNd9b7C1jvLb5SCfumaQ949upKe6jH-Vv_rLQFtRx0YRWshoxZrTUt41EnuGvkS6DxQeQ"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let targetDate = dateFormatter.date(from: "23/10/2023") else {
            XCTFail("Failed to create target date")
            return
        }
        
        XCTAssert(JWTDecoder.isTokenValid(token, targetDate: targetDate))
    }
    
    func testBadToken() throws {
        let token = "LQFtRx0YRWshoxZrTUt41EnuGvkS6DxQeQ"
        
        XCTAssertFalse(JWTDecoder.isTokenValid(token))
    }

    func testExpiredToken() throws {
        let token = "eyJhbGciOiJFUzI1NiIsImtpZCI6Ik1ZREM1NFBDWjkiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJBNEQ0REtBUEhOIiwiZXhwIjoxNzEzNzI3MDI5LCJpYXQiOjE2OTgwMDIyMjl9.fU2CtW1i1CVnN2xi9cNd9b7C1jvLb5SCfumaQ949upKe6jH-Vv_rLQFtRx0YRWshoxZrTUt41EnuGvkS6DxQeQ"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        guard let targetDate = dateFormatter.date(from: "16/01/2033") else {
            XCTFail("Failed to create target date")
            return
        }
        
        XCTAssertFalse(JWTDecoder.isTokenValid(token, targetDate: targetDate))
    }
}
