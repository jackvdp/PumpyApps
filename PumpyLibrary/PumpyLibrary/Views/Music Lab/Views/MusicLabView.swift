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
                           Q:QueueProtocol,
                           P:PlaylistProtocol>: View {
    
    @EnvironmentObject var labManager: MusicLabManager
    @EnvironmentObject var queueManager: Q
    @EnvironmentObject var authManager: AuthorisationManager
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack {
                tracks
                Divider()
                playlistSize
                Divider()
                genres
                Divider()
                sliders
            }
            .padding(.horizontal)
        }
        .mask { mask }
        .overlay(alignment: .bottom) { button }
        .navigationTitle("Music Lab")
        .pumpyBackground()
        .onAppear() {
            labManager.getGenres(authManager: authManager)
        }
    }

    // MARK: - Genres
    
    @State private var showGenreSheet = false
    
    var genres: some View {
        HStack {
            Text("Genres:")
            Spacer()
            Text(
                labManager.selectedGenres.isEmpty ?
                "-- Select --" : labManager.selectedGenres.joined(separator: ", ")
            )
            .foregroundColor(.pumpyPink)
            .onTapGesture {
                showGenreSheet = true
            }
        }
        .font(.subheadline)
        .sheet(isPresented: $showGenreSheet) {
            GenreList()
        }
    }
    
    // MARK: - Playlist Size
    
    var sizes = [5, 10, 20, 50]
    
    var playlistSize: some View {
        HStack {
            Text("Playlist size:")
            Spacer()
            Picker("", selection: $labManager.playlistSize) {
                ForEach(sizes, id: \.self) {
                    Text($0.description + " tracks")
                }
            }
        }
        .font(.subheadline)
        .tint(.pumpyPink)
    }
    
    // MARK: - Tracks
    
    var tracks: some View {
        ForEach(labManager.seedTracks, id: \.sourceID) { track in
            Divider()
            TrackRow<N,B,P,Q>(track: track,
                              authManager: authManager,
                              tapAction: { playFromPosition(track: track) })
        }
        .onDelete(perform: labManager.removeTrack)
    }
    
    func playFromPosition(track: Track) {
        guard let id = track.amStoreID else { return }
        queueManager.playTrackNow(id: id)
    }
    
    // MARK: - Attribute Sliders
    
    var sliders: some View {
        VStack(alignment: .leading) {
            tunableAttributesHeader
            ForEach(labManager.properties, id: \.name) { property in
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
    
    // MARK: - Bottom & Button
    
    var emptySpace: some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(height: 80)
    }
    
    var button: some View {
        NavigationLink(destination: LabResultView<P,N,B,Q>()) {
            Text("Create")
                .bold()
                .padding(4)
                .frame(maxWidth: .infinity)
        }
        .accentColor(.pumpyPink)
        .buttonStyle(.borderedProminent)
        .padding([.horizontal, .bottom])
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
                    MusicLabView<
                        MockNowPlayingManager,
                        MockBlockedTracks,
                        MockQueueManager,
                        MockPlaylistManager
                    >()
                    MenuTrackView<MockNowPlayingManager, MockBlockedTracks,MockPlaylistManager,MockHomeVM>()
                }
            }.environmentObject(labManager)
            NavigationView {
                MusicLabView<
                    MockNowPlayingManager,
                    MockBlockedTracks,
                    MockQueueManager,
                    MockPlaylistManager
                >()
            }.environmentObject(MusicLabManager())
        }
            .preferredColorScheme(.dark)
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockQueueManager())
            .environmentObject(MockPlaylistManager())
            .environmentObject(AlarmManager())
            .environmentObject(MockHomeVM())
            .environmentObject(AuthorisationManager())
            .environmentObject(BookmarkedManager())
    }
}
