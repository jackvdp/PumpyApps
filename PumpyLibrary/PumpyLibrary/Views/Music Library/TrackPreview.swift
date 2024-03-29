//
//  TrackPreview.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 08/10/2022.
//

import SwiftUI
import PumpyAnalytics

struct TrackPreview: View {
    
    @ObservedObject var track: PumpyAnalytics.Track
    private let controller = AnalyseController()
    @EnvironmentObject var authManager: AuthorisationManager
    private let contentWidth: CGFloat = 200
    
    var body: some View {
        VStack(spacing: 10) {
            trackDetails
            if let spotItem = track.spotifyItem,
               let amItem = track.appleMusicItem {
                Divider()
                trackFeatures(amItem, spotItem: spotItem)
                    .animation(.easeIn, value: track)
            }
            if let analysis = track.audioFeatures {
                Divider()
                trackAnalysis(analysis)
                    .animation(.easeIn, value: track)
            }
        }
        .frame(width: contentWidth)
        .padding()
        .task {
            await analyseTrack()
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
    
    private func analyseTrack() async {
        guard track.audioFeatures == nil else {
            // For tracks that have already been analysed through this process
            return
        }
        if track.isrc == nil {
            await controller.analyseMediaPlayerTracks(tracks: [track], authManager: authManager)
        } else {
            await controller.analyseTracks(tracks: [track], authManager: authManager)
        }
    }
    
}

// MARK: - Previews

struct TrackPreview_Previews: PreviewProvider {
    static let analysedTrack = PumpyAnalytics.MockData.trackWithLongDetails
    
    static var previews: some View {
        Group {
            TrackPreview(track: analysedTrack)
                .border(.black)
                .preferredColorScheme(.dark)
                .padding()
                .background(Color.indigo)
                .environmentObject(AuthorisationManager())
                .environmentObject(MusicLabManager())
        }
    }
}

