//
//  TrackPreview.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 08/10/2022.
//

import SwiftUI
import PumpyAnalytics

struct TrackPreview: View {
    
    let track: Track
    @State var analysedTrack: PumpyAnalytics.Track?
    private let controller = AnalyseController()
    @EnvironmentObject var authManager: AuthorisationManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            trackDetails
            if let spotItem = analysedTrack?.spotifyItem,
               let amItem = analysedTrack?.appleMusicItem {
                Divider()
                trackFeatures(amItem, spotItem: spotItem)
                    .animation(.easeIn, value: analysedTrack)
            }
            
            if let analysis = analysedTrack?.audioFeatures {
                Divider()
                trackAnalysis(analysis)
                    .animation(.easeIn, value: analysedTrack)
            }
        }
        .padding()
        .onAppear() {
            analyseTrack()
        }
    }
    
    private func analyseTrack() {
        controller.analyseMediaPlayerTracks(amIDs: [track.playbackStoreID],
                                            authManager: authManager) { tracks in
            guard let track = tracks.first else { return }
            withAnimation {
                analysedTrack = track
            }
        }
    }
    
    private var trackDetails: some View {
        VStack(alignment: .leading) {
            ArtworkView(artworkURL: track.artworkURL, size: 200)
            Text(track.title ?? "N/A")
            Text(track.artist ?? "N/A")
                .opacity(0.5)
        }
    }
    
    func trackAnalysis(_ features: PumpyAnalytics.AudioFeatures) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            analysisRow(label: "Peak", value: features.pumpyScoreString)
            analysisRow(label: "Dance", value: features.danceabilityString)
            analysisRow(label: "Energy", value: features.energyString)
            analysisRow(label: "Happiness", value: features.valenceString)
            analysisRow(label: "Loud", value: features.loudnessString)
            analysisRow(label: "Instrumental", value: features.instrumentalnessString)
            analysisRow(label: "Acoustic", value: features.acousticnessString)
            analysisRow(label: "Live", value: features.livelinessString)
        }
    }
    
    func trackFeatures(_ amItem: AppleMusicItem, spotItem: SpotifyItem) -> some View {
        var genres: String {
            var g = amItem.genres
            g.removeAll(where: { $0 == "Music"})
            return g.joined(separator: ", ")
        }
        
        return VStack(alignment: .leading, spacing: 5) {
            analysisRow(label: "Popularity", value: spotItem.popularityString ?? "–")
            analysisRow(label: "Year", value: spotItem.year?.description ?? "–")
            analysisRow(label: "Genre", value: genres)
        }
    }
    
    func analysisRow(label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(label + ":")
                .opacity(0.5)
                .frame(width: 100, alignment: .leading)
            Spacer()
            Text(value)
                .frame(width: 100, alignment: .trailing)
        }
    }
    
}

struct TrackPreview_Previews: PreviewProvider {
    static let analysedTrack = PumpyAnalytics.MockData.trackWithFeatures
    
    static var previews: some View {
        Group {
            TrackPreview(track: MockData.track, analysedTrack: analysedTrack)
                .preferredColorScheme(.dark)
                .padding(100)
                .background(Color.indigo)
                .environmentObject(AuthorisationManager())
            TrackPreview(track: MockData.track).trackAnalysis(analysedTrack.audioFeatures!)
                .preferredColorScheme(.dark)
                .padding(100)
                .background(Color.indigo)
                .environmentObject(AuthorisationManager())
        }
    }
}

