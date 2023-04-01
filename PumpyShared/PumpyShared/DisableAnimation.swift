//
//  DisableAnimation.swift
//  PumpyShared
//
//  Created by Jack Vanderpump on 25/03/2023.
//

import SwiftUI

struct DisableAnimation: ViewModifier {
    func body(content: Content) -> some View {
        content
            .transaction { transaction in
                transaction.animation = nil
            }
        }
}

extension View {
    public func disableAnimation() -> some View {
        self.modifier(DisableAnimation())
    }
}
