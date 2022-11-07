//
//  Debouncer.swift
//  PumpyShared
//
//  Created by Jack Vanderpump on 01/11/2022.
//

import Foundation

public class Debouncer {
    
    private let timeInterval: TimeInterval
    private var timer: Timer?
    
    public typealias Handler = () -> Void
    public var handler: Handler? {
        didSet {
            renewInterval()
        }
    }
    
    public init(_ time: TimeInterval = 0.3) {
        timeInterval = time
    }
    
    private func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] (timer) in
            self?.timeIntervalDidFinish(for: timer)
        }
    }
    
    private func timeIntervalDidFinish(for timer: Timer) {
        guard timer.isValid else {
            return
        }
        timer.invalidate()
        handler?()
        handler = nil
    }
    
}
