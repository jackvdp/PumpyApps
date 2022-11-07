//
//  NavigationBarView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct NavigationBar<B: BlockedTracksProtocol, N:NowPlayingProtocol, H:HomeProtocol, Content: View>: View {
    
    @EnvironmentObject var nowPlayingManager: N
    @EnvironmentObject var blockedTracksManager: B
    @EnvironmentObject var homeVM: H
    var destinationView: Content
     
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
            homeVM.showMenu = true
        }) {
            Image(systemName: "line.horizontal.3")
                .resizable()
                .foregroundColor(Color.white)
                .frame(width: 25, height: 25, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .font(Font.title.weight(.ultraLight))
        }
        .fullScreenCover(isPresented: $homeVM.showMenu) {
            destinationView
        }
    }
    
}


#if DEBUG
struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar<MockBlockedTracks, MockNowPlayingManager, MockHomeVM, EmptyView>(destinationView: EmptyView())
            .environmentObject(MockHomeVM())
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockNowPlayingManager())
    }
}
#endif
