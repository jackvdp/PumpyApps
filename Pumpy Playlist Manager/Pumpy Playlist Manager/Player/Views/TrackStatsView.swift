//
//  TrackStatsView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 03/08/2022.
//

import SwiftUI
import PumpyAnalytics

struct TrackStatsView: View {
    
    @ObservedObject var track: Track
    
    var body: some View {
        StatsView(title: track.title,
                  artist: track.artist,
                  genres: track.appleMusicItem?.genres,
                  tempoString: track.audioFeatures?.tempoString,
                  pumpyScoreString: track.audioFeatures?.pumpyScoreString,
                  danceabilityString: track.audioFeatures?.danceabilityString,
                  energyString: track.audioFeatures?.energyString,
                  valenceString: track.audioFeatures?.valenceString,
                  loudnessString: track.audioFeatures?.loudnessString,
                  instrumentalnessString: track.audioFeatures?.instrumentalnessString,
                  acousticnessString: track.audioFeatures?.acousticnessString,
                  livelinessString: track.audioFeatures?.livelinessString,
                  popularityString: track.spotifyItem?.popularityString,
                  year: track.spotifyItem?.year?.description)
    }
}

struct TrackStatsView_Previews: PreviewProvider {
    static var previews: some View {
        TrackStatsView(track: MockData.track)
    }
}
