//
//  CircularButton.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/03/2022.
//

import Foundation
import SwiftUI
import PumpyAnalytics

struct CircularButtonView: View {
    
    let size: CGFloat
    let systemName: String
    let font: Font
    let action: () -> ()
    
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .frame(width: size, height: size)
                .font(font)
                .foregroundColor(.white)
                .background(isHovering ? Color.pumpyPinkDark : Color.pumpyPink)
                .clipShape(Circle())
                .onHover { isHovering in
                    self.isHovering = isHovering
                }
        }
        .buttonStyle(.plain)
    }
    
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.pumpyPink)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.5),
                    radius: configuration.isPressed ? 7 : 5,
                    x: configuration.isPressed ? 7 : 5,
                    y: configuration.isPressed ? 7 : 5)
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
            .buttonStyle(.plain)
    }
}

struct SytyledButtonsView_Previews: PreviewProvider {
    
    static var previews: some View {
        Button("Test") {
            print("test")
        }.buttonStyle(GrowingButton())
            .frame(width: 80, height: 80, alignment: .center)
    }
}
