//
//  MusicLabView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 08/03/2023.
//

import SwiftUI
import PumpyAnalytics

public struct MusicLabView<N:NowPlayingProtocol,
                           B:BlockedTracksProtocol,
                           T:TokenProtocol,
                           Q:QueueProtocol,
                           P:PlaylistProtocol>: View {
    
    @EnvironmentObject var labManager: MusicLabManager
    
    public init() {}
    
    public var body: some View {
        PumpyList {
            tracks
            slider
            slider
            slider
            slider
        }
        .mask {
            mask
        }
        .listStyle(.plain)
        .overlay(alignment: .bottom) {
            button
        }
        .navigationTitle("Music Lab")
        .pumpyBackground()
    }
    
    var tracks: some View {
        ForEach(labManager.seedTracks.indices, id: \.self) { i in
            TrackRow<T,N,B,P,Q>(track: labManager.seedTracks[i])
        }
        .onDelete(perform: labManager.removeTrack)
    }
    
    @State private var celsius: Double = 0
    var slider: some View {
        VStack {
            HStack(spacing: -4) {
                Slider(value: $celsius, in: -100...100)
                    .accentColor(.pumpyPink)
                    .padding(.trailing)
                    .rotationEffect(.degrees(180))
                    .offset(y: 1)
                Slider(value: $celsius, in: -100...100)
                    .accentColor(.pumpyPink)
                    .padding(.trailing)
            }
            Text("\(celsius, specifier: "%.1f") Celsius")
        }
    }
    
    var button: some View {
        Button(action: {
            //
        }, label: {
            Text("Create")
                .padding(4)
                .frame(maxWidth: .infinity)
        })
        .accentColor(.pumpyPink)
        .buttonStyle(.borderedProminent)
        .padding(.horizontal)
    }

    var mask: some View {
        LinearGradient(
            gradient:
                Gradient(colors:
                            Array<Color>(repeating: .white, count: 6) + Array<Color>(repeating: .white.opacity(0), count: 1)),
            startPoint: .top,
            endPoint: .bottom)
    }
}

// MARK: - Preview

struct MusicLabView_Previews: PreviewProvider {
    
    static var labManager: MusicLabManager = {
        let lm = MusicLabManager()
        lm.addTrack(MockData.track)
        lm.addTrack(MockData.track)
        lm.addTrack(MockData.track)
        lm.addTrack(MockData.track)
        lm.addTrack(MockData.track)
        lm.addTrack(MockData.track)
        return lm
    }()
    
    static var previews: some View {
        NavigationView {
            MusicLabView<MockNowPlayingManager,
            MockBlockedTracks,
            MockTokenManager,
            MockQueueManager,MockPlaylistManager>()
        }
            .preferredColorScheme(.dark)
            .environmentObject(labManager)
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockTokenManager())
            .environmentObject(MockQueueManager())
            .environmentObject(MockPlaylistManager())
    }
}
