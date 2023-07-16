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
import PopupView
import PumpyAnalytics

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
        VStack(spacing: 32) {
            HStack {
                Spacer()
                backButton.disabled(notPlaying)
                Spacer()
                playButton
                Spacer()
                fastForwardButton.disabled(notPlaying)
                Spacer()
            }
            HStack {
                Spacer()
                changeEnergyButton.disabled(notPlaying)
                Spacer()
                upNextButton.disabled(notPlaying)
                Spacer()
                moreInfoButton.frame(width: 25).disabled(notPlaying)
                Spacer()
                AirPlayView().frame(width: 25, height: 15)
                Spacer()
            }
        }.padding(.horizontal)
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
    
    var backButton: some View {
        Button(action: {
            homeVM.skipBack()
        }) {
            Image(systemName: "backward.fill")
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
                .frame(width: 25, height: 25, alignment: .center)
                .accentColor(homeVM.pageType == .upNext ? .pumpyPink : .white)
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
                .frame(width: 25, height: 25, alignment: .center)
                .foregroundColor(queueManager.analysingEnergy ? .pumpyPink : .white)
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
    
    @State private var showPopup = false
    @State private var analysedTrack: PumpyAnalytics.Track?
    
    var moreInfoButton: some View {
        Button(action: {
            showPopup = true
        }) {
            Image(systemName: "ellipsis.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20, alignment: .center)
                .foregroundColor(.white)
        }
        .buttonStyle(.plain)
        .popup(isPresented: $showPopup) {
            if let track = nowPlayingManager.currentTrack {
                VStack {
                    TrackPreview(track: track, analysedTrack: $analysedTrack)
                    LabButtons(analysedTrack: $analysedTrack)
                        .buttonStyle(.bordered)
                        .tint(.pumpyPink)
                }
                .padding()
                .background(.black.opacity(0.6))
                .cornerRadius(16)
            } else {
                Text("No track playing")
            }
        } customize: { popup in
            popup
                .type(.default)
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .closeOnTap(false)
                .backgroundView {
                    Rectangle().foregroundStyle(Material.regular)
                }
        }
        .onReceive(nowPlayingManager.currentTrack.publisher) { newValue in
            analysedTrack = nil
        }
    }

}

#if DEBUG
struct PlayerControls_Previews: PreviewProvider {
    
    static var nowPlaying: MockNowPlayingManager {
        let np = MockNowPlayingManager()
        np.currentTrack = QueueTrack(title: "Test track", artist: "Dave", artworkURL: nil, playbackStoreID: "", isExplicitItem: true)
        return np
    }

    static var previews: some View {
        PlayerControls<MockPlaylistManager,
                       MockNowPlayingManager,
                       MockHomeVM,
                       MockQueueManager>(isPortrait: false, notPlaying: false)
            .environmentObject(MockHomeVM())
            .environmentObject(nowPlaying)
            .environmentObject(MockQueueManager())
            .environmentObject(MockPlaylistManager())
            .environmentObject(AlarmManager())
            .environmentObject(AuthorisationManager())
            .preferredColorScheme(.dark)
            .padding()
        PlayerControls<MockPlaylistManager,
                       MockNowPlayingManager,
                       MockHomeVM,
                       MockQueueManager>(isPortrait: true, notPlaying: true)
            .environmentObject(MockHomeVM())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockQueueManager())
            .environmentObject(MockPlaylistManager())
            .environmentObject(AlarmManager())
            .preferredColorScheme(.dark)
    }
}
#endif


