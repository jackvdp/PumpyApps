//
//  Background.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 07/03/2023.
//

import SwiftUI

struct BackgroundView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background {
                ArtworkView().background
            }
    }
}

extension View {
    public func pumpyBackground() -> some View {
        self.modifier(BackgroundView())
    }
}
