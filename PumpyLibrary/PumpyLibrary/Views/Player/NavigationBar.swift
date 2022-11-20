//
//  NavigationBarView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct NavigationBar<B: BlockedTracksProtocol, N:NowPlayingProtocol, H:HomeProtocol>: View {
    
    @EnvironmentObject var nowPlayingManager: N
    @EnvironmentObject var blockedTracksManager: B
    @EnvironmentObject var homeVM: H
     
    var body: some View {
        HStack {
            if let track = nowPlayingManager.currentTrack {
                DislikeButton<N,B>(track: track, nowPlayingManager: nowPlayingManager)
            }
            Spacer()
            PumpyView()
                .frame(width: 120, height: 40)
            Spacer()
            menuButton
        }
    }
    
    var menuButton: some View {
        Button(action: {
            homeVM.showPlayer = false
        }) {
            Image(systemName: "chevron.down")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.white)
                .frame(width: 20, alignment: .center)
                
        }
    }
    
}


#if DEBUG
struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar<MockBlockedTracks, MockNowPlayingManager, MockHomeVM>()
            .environmentObject(MockHomeVM())
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockNowPlayingManager())
            .preferredColorScheme(.dark)
    }
}
#endif
