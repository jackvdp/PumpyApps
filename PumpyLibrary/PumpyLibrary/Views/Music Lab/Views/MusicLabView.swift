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
                           P:PlaylistProtocol,
                           H:HomeProtocol>: View {
    
    @EnvironmentObject var labManager: MusicLabManager
    
    public init() {}
    
    public var body: some View {
        Group {
            if labManager.seedTracks.isEmpty {
                emptyView
            } else {
                notEmptyView
            }
        }
        .navigationTitle("Music Lab")
        .pumpyBackground()
    }
    
    var emptyView: some View {
        VStack(spacing: 50) {
            Text("Select tracks and make some music!")
                .font(.title).bold()
                .multilineTextAlignment(.center)
                .opacity(0.5)
            Text("Go to Library or Catalog, long press a track and add to the Music Lab.\n\nMusic Lab allows users to create playlists based on up to 5 chosen tracks and tuned using tunable attributes.")
                .opacity(0.5)
        }.padding().frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var notEmptyView: some View {
        PumpyList {
            tracks
            sliders
        }
        .listStyle(.plain)
        .mask {
            mask
        }
        .overlay(alignment: .bottom) {
            button
        }
    }
    
    var tracks: some View {
        ForEach(labManager.seedTracks.indices, id: \.self) { i in
            TrackRow<T,N,B,P,Q>(track: labManager.seedTracks[i])
        }
        .onDelete(perform: labManager.removeTrack)
    }
    
    var sliders: some View {
        VStack(alignment: .leading) {
            tunableAttributesHeader
            ForEach(labManager.properties.indices, id: \.self) { index in
                let property = labManager.properties[index]
                PropertySelector(prop: property)
                    .padding()
                    .background(.ultraThinMaterial.opacity(0.5))
                    .cornerRadius(8)
                    .padding(.horizontal, -8)
            }
            emptySpace
        }
    }
    
    var tunableAttributesHeader: some View {
        HStack(spacing: 20) {
            Text("Tunable attributes:").bold()
            Spacer()
            Button("Enable All") {
                labManager.enableAllAttributes()
            }
            .buttonStyle(.plain)
            .disabled(labManager.allTracksEnabled)
            Button("Disable All") {
                labManager.disableAllAttributes()
            }
            .buttonStyle(.plain)
            .disabled(labManager.allTracksDisabled)
        }
        .opacity(0.5)
        .padding(.top)
        .font(.subheadline)
    }
    
    var emptySpace: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(height: 80)
    }
    
    var button: some View {
        NavigationLink(destination: LabResultView<H,P,N,B,T,Q>()) {
            Text("Create")
                .bold()
                .padding(4)
                .frame(maxWidth: .infinity)
        }
        .accentColor(.pumpyPink)
        .buttonStyle(.borderedProminent)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }

    var mask: some View {
        VStack(spacing: 0) {
            Color.white
            LinearGradient(
                gradient:
                    Gradient(colors: [.white] + Array<Color>(repeating: .clear, count: 3)),
                startPoint: .top,
                endPoint: .bottom)
            .frame(height: 100)
        }
    }
}

// MARK: - Preview

struct MusicLabView_Previews: PreviewProvider {
    
    static var labManager: MusicLabManager = {
        let lm = MusicLabManager()
        lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
        lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
        lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
        lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
        lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
        lm.addTrack(PumpyAnalytics.MockData.trackWithFeatures)
        return lm
    }()
    
    static var previews: some View {
        Group {
            NavigationView {
                VStack {
                    MusicLabView<MockNowPlayingManager,
                    MockBlockedTracks,
                    MockTokenManager,
                    MockQueueManager,MockPlaylistManager,MockHomeVM>()
                    MenuTrackView<MockTokenManager,MockNowPlayingManager, MockBlockedTracks,MockPlaylistManager, MockHomeVM>()
                }
            }.environmentObject(labManager)
            NavigationView {
                MusicLabView<MockNowPlayingManager,
                MockBlockedTracks,
                MockTokenManager,
                MockQueueManager,MockPlaylistManager,MockHomeVM>()
            }.environmentObject(MusicLabManager())
        }
            .preferredColorScheme(.dark)
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockTokenManager())
            .environmentObject(MockQueueManager())
            .environmentObject(MockPlaylistManager())
            .environmentObject(AlarmManager())
            .environmentObject(MockHomeVM())
    }
}
