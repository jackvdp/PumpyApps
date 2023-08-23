//
//  Background.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 07/03/2023.
//

import SwiftUI

extension View {
    public func pumpyBackground() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundView.gradient.edgesIgnoringSafeArea(.all))
    }
    
    public func playerBackground() -> some View {
        self.background(BackgroundView())
    }
}

private struct BackgroundView: View {
    
    @ObservedObject var handler = BackgroundColourHandler.shared
    
    var body: some View {
        Group {
            if let colour = handler.colour {
                Color(uiColor: colour)
            } else {
                Color.pumpyBlue
            }
        }.overlay {
            Color.black.opacity(0.5)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    static var gradient: some View {
        let gradient = Gradient(colors: [
            .pumpyBlue, .pumpyBlue, .pumpyBlue, .pumpyPurple, .pumpyPurple
        ])
        return LinearGradient(gradient: gradient,
                              startPoint: .top,
                              endPoint: .bottom)
        .overlay {
            Color.black.opacity(0.6)
        }
        .blur(radius: 20)
    }
}

public class BackgroundColourHandler: ObservableObject {
    public static let shared = BackgroundColourHandler()
    private init() {}
    
    @Published private(set) var colour: UIColor?
    
    public func setColour(fromImage image: UIImage?) {
        colour = image?.averageColor
    }
}
