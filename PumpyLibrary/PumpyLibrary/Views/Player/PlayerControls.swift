//
//  PlayerControls.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import AVKit
import MediaPlayer

struct PlayerControls<P:PlaylistProtocol,
                      N:NowPlayingProtocol,
                      H:HomeProtocol,
                      Q:QueueProtocol>: View {
    
    @EnvironmentObject var homeVM: H
    @EnvironmentObject var playlistManager: P
    @EnvironmentObject var nowPlayingManager: N
    @EnvironmentObject var queueManager: Q
    @EnvironmentObject var alarmData: AlarmManager
    @State private var showingOptions: Bool = false
    
    var isPortrait: Bool
    var notPlaying: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 40.0) {
            changeEnergyButton
                .disabled(notPlaying)
            if isPortrait {
                upNextButton
                    .disabled(notPlaying)
            }
            playButton
            fastForwardButton
                .disabled(notPlaying)
        }
    }
    
    var playButton: some View {
        Image(systemName: nowPlayingManager.playButtonState == .playing ? "pause.fill" : "play.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40, alignment: .center)
            .accentColor(.white)
            .onTapGesture {
                homeVM.playPause(alarmData: alarmData,
                                 playlistManager: playlistManager)
            }
            .onLongPressGesture(minimumDuration: 2) {
                homeVM.coldStart(alarmData: alarmData,
                                 playlistManager: playlistManager)
            }
        
    }

    var fastForwardButton: some View {
        Button(action: {
            homeVM.skipToNextItem()
        }) {
            Image(systemName: "forward.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40, alignment: .center)
                .accentColor(.white)
        }
    }

    var upNextButton: some View {
        Button(action: {
            withAnimation {
                switch homeVM.pageType {
                case .artwork:
                    homeVM.pageType = .upNext
                case .upNext:
                    homeVM.pageType = .artwork
                }
            }
        }) {
            Image(systemName: "list.bullet")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
                .accentColor(homeVM.pageType == .upNext ? .pumpyPink : .white)
                .font(.title.weight(.light))
        }
        .buttonStyle(.plain)
    }
    
    var changeEnergyButton: some View {
        Button(action: {
            showingOptions = true
        }) {
            Image(systemName: "bolt")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30, alignment: .center)
                .foregroundColor(queueManager.analysingEnergy ? .pumpyPink : .white)
                .font(.title.weight(.light))
        }
        .disabled(queueManager.analysingEnergy)
        .confirmationDialog("Change energy of upcoming tracks", isPresented: $showingOptions, titleVisibility: .visible) {
            Button {
                queueManager.increaseEnergy()
            } label: {
                Text("Increase Energy")
            }
            Button {
                queueManager.decreaseEnergy()
            } label: {
                Text("Decrease Energy")
            }
        }
        .buttonStyle(.plain)
    }

}

#if DEBUG
struct PlayerControls_Previews: PreviewProvider {

    static var previews: some View {
        PlayerControls<MockPlaylistManager,
                       MockNowPlayingManager,
                       MockHomeVM,
                       MockQueueManager>(isPortrait: false, notPlaying: true)
            .environmentObject(MockHomeVM())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockQueueManager())
            .environmentObject(MockPlaylistManager())
            .environmentObject(AlarmManager(username: "Text", preview: true))
            .preferredColorScheme(.dark)
        PlayerControls<MockPlaylistManager,
                       MockNowPlayingManager,
                       MockHomeVM,
                       MockQueueManager>(isPortrait: true, notPlaying: true)
            .environmentObject(MockHomeVM())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockQueueManager())
            .environmentObject(MockPlaylistManager())
            .environmentObject(AlarmManager(username: "Text", preview: true))
            .preferredColorScheme(.dark)
    }
}
#endif


