//
//  PumpyNavigation.swift
//  PumpyShared
//
//  Created by Jack Vanderpump on 26/11/2022.
//

import SwiftUI

public struct PumpyNavigation: ViewModifier {
    let isLandscape: Bool
    
    public func body(content: Content) -> some View {
        if isLandscape {
            content
                .navigationViewStyle(.columns)
        } else {
            #if os(macOS)
            content
                .navigationViewStyle(.columns)
            #else
            content
                .navigationViewStyle(.stack)
            #endif
        }
    }
}

public extension View {
    func pumpyNavigation(isLandscape: Bool) -> some View {
        modifier(PumpyNavigation(isLandscape: isLandscape))
    }
}
