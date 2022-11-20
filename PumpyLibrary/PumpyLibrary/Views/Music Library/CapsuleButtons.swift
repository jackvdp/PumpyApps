//
//  CapsuleButtons.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 23/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct PlayCapsules: View {
    public init(playNext: @escaping () -> Void, playNow: @escaping () -> Void) {
        self.playNextAction = playNext
        self.playNowAction = playNow
    }
    
    var playNextAction: () -> Void
    var playNowAction: () -> Void
    
    public var body: some View {
        HStack {
            CapsuleButton(title: "Play Next",
                          iconName: "arrow.turn.down.right",
                          action: playNextAction)
                .frame(maxWidth: .infinity)
            CapsuleButton(title: "Play Now",
                          iconName: "play.fill",
                          action: playNowAction)
                .frame(maxWidth: .infinity)
        }
    }
}

struct CapsuleButton: View {
    
    var title: String
    var iconName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: iconName).foregroundColor(.white)
                Text(title).foregroundColor(.white)
            }
            .padding()
            .background(Color.pumpyPink)
            .clipShape(Capsule())
            .shadow(color: .black, radius:10)
        }
        .buttonStyle(.plain)
    }
}
