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
            .background(gradient)
    }
    
    var gradient: some View {
        let gradient = Gradient(colors: [
            .black, .pumpyBlue, .pumpyBlue, .pumpyPurple, .pumpyPurple
        ])
        return LinearGradient(gradient: gradient,
                              startPoint: .top,
                              endPoint: .bottom)
        .overlay {
            Color.black.opacity(0.6)
        }
        .blur(radius: 20)
    }
    
    static func solid(backgroundColour: UIColor?) -> some View {
        Group {
            if let bgC = backgroundColour {
                Color(uiColor: bgC)
            } else {
                Color.pumpyBlue
            }
        }.overlay {
            Color.black.opacity(0.6)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    public func pumpyBackground() -> some View {
        self.modifier(BackgroundView())
    }
}
