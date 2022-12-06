//
//  Debouncer.swift
//  PumpyShared
//
//  Created by Jack Vanderpump on 01/11/2022.
//

import Foundation

/**
 A debouncer class that can be used to prevent rapid firing of a function.
 */
public class Debouncer {
    
    private let timeInterval: TimeInterval
    private var timer: Timer?
    public typealias Handler = () -> Void
    
    /// Call this method passing it the function that you want debounced.
    /// - Parameter callback: The function to be debounced.
    public func handle(_ callback: @escaping Handler) {
        handler = callback
    }
    
    /// Initalise the Debouncer class
    /// - Parameter time: The amount of time to wait before allowing the function to be fired.
    public init(_ time: TimeInterval = 0.3) {
        timeInterval = time
    }
    
    private var handler: Handler? {
        didSet {
            renewInterval()
        }
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
