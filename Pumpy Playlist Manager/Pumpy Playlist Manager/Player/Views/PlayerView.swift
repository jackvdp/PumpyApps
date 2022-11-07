//
//  PlayerView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 13/02/2022.
//

import SwiftUI

struct PlayerView: View {

    @EnvironmentObject var playerManager: PlayerManager
    @State private var showing = true
    
    var body: some View {
//        VStack(alignment: .trailing, spacing: 0) {
//            PlayerShowButton(showing: $showing)
            ZStack(alignment: .top) {
                PlayerContent(playerManager: playerManager)
                ProgressBar(currentTime: playerManager.currentTime)
            }
            .background(Color(NSColor.windowBackgroundColor))
            .frame(height: showing ? 109 : 2)
//        }
    }
    
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
            .environmentObject(PlayerManager())
    }
}
