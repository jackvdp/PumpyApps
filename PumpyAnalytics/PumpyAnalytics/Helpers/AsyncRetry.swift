//
//  AsycRetry.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 14/08/2023.
//

import Foundation

struct RetryRequest {
    
    func retryAsync() async {
        let retryInt = 2
        let nanoseconds = UInt64(retryInt) * 1_000_000_000
        try? await Task.sleep(nanoseconds: nanoseconds)
    }
    
}
