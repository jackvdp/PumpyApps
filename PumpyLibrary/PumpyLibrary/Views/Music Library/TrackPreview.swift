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
    @Binding var analysedTrack: PumpyAnalytics.Track?
    private let controller = AnalyseController()
    @EnvironmentObject var authManager: AuthorisationManager
    private let contentWidth: CGFloat = 200
    
    var body: some View {
        VStack(spacing: 10) {
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
        .frame(width: contentWidth)
        .padding()
        .task {
            analyseTrack()
        }
    }
    
    // MARK: - Components
    
    private var trackDetails: some View {
        VStack(alignment: .leading) {
            ArtworkView(collection: track, size: contentWidth)
            Text(track.name)
                .frame(width: contentWidth, alignment: .leading)
                .lineLimit(2)
            Text(track.artistName)
                .frame(width: contentWidth, alignment: .leading)
                .lineLimit(2)
                .opacity(0.5)
        }
    }
    
    private func trackFeatures(_ amItem: AppleMusicItem, spotItem: SpotifyItem) -> some View {
        var genres: String {
            var g = amItem.genres
            g.removeAll(where: { $0 == "Music"})
            switch g.count {
            case let i where i > 1:
                return "\(g[0]), \(g[1])"
            default:
                return g.first ?? "–"
            }
        }
        
        return VStack(alignment: .leading, spacing: 5) {
            analysisRow(label: "Popularity", value: spotItem.popularityString ?? "–")
            analysisRow(label: "Year", value: spotItem.year?.description ?? "–")
            analysisRow(label: "Genre", value: genres, labelWidth: 55)
        }
    }
    
    private func trackAnalysis(_ features: PumpyAnalytics.AudioFeatures) -> some View {
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
    
    private func analysisRow(label: String, value: String, labelWidth: CGFloat = 100) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(label + ":")
                .opacity(0.5)
                .frame(width: labelWidth, alignment: .leading)
            Text(value)
                .frame(width: contentWidth - labelWidth, alignment: .trailing)
                .lineLimit(2)
        }
    }
    
    // MARK: - Methods
    
    private func analyseTrack() {
        guard analysedTrack?.audioFeatures == nil else {
            // For tracks that have already been analysed through this process
            return
        }
        if let analyticsTrack = track as? PumpyAnalytics.Track {
            if analyticsTrack.audioFeatures != nil {
                withAnimation {
                    // For tracks that have already been analysed
                    analysedTrack = analyticsTrack
                }
            } else {
                controller.analyseTracks(tracks: [analyticsTrack],
                                         authManager: authManager) { tracks in
                    guard let track = tracks.first else { return }
                    withAnimation {
                        // For analytics tracks that haven't been analysed
                        analysedTrack = track
                    }
                }
            }
        } else {
            guard let id = track.amStoreID else { return }
            controller.analyseMediaPlayerTracks(amIDs: [id],
                                                authManager: authManager) { tracks in
                guard let track = tracks.first else { return }
                withAnimation {
                    // For MPMediaItems
                    analysedTrack = track
                }
            }
        }
    }
    
}

// MARK: - Previews

struct TrackPreview_Previews: PreviewProvider {
    static let analysedTrack = PumpyAnalytics.MockData.trackWithLongDetails
    
    static var previews: some View {
        Group {
            TrackPreview(track: analysedTrack, analysedTrack: .constant(analysedTrack))
                .border(.black)
                .preferredColorScheme(.dark)
                .padding()
                .background(Color.indigo)
                .environmentObject(AuthorisationManager())
                .environmentObject(MusicLabManager())
        }
    }
}

