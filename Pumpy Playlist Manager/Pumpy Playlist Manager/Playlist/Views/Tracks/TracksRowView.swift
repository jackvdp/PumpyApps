//
//  NewTracksView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/06/2022.
//

import SwiftUI
import PumpyAnalytics

struct TracksRowView: View {
    
    @ObservedObject var track: Track
    let statsFont = Font.caption
    @ObservedObject var showingColumn: ColumnsShowing
    let widthOfTable: CGFloat
    
    var body: some View {
        HStack(spacing: 10) {
            TracksTitleContent(track: track)
                .frame(width: showingColumn.columnWidth(widthOfTable) + 150)
                .layoutPriority(1)
            Spacer(minLength: 10)
            Group {
                if showingColumn.columns[0].showing {
                    Text(track.audioFeatures?.tempoString ?? "–")
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
                if showingColumn.columns[1].showing {
                    Text(track.audioFeatures?.pumpyScoreString ?? "–")
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
                if showingColumn.columns[2].showing {
                    Text(track.audioFeatures?.danceabilityString ?? "–")
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
                if showingColumn.columns[3].showing {
                    Text(track.audioFeatures?.energyString ?? "–")
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
                if showingColumn.columns[4].showing {
                    Text(track.audioFeatures?.valenceString ?? "–")
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
            }
            Group {
                if showingColumn.columns[5].showing {
                    Text(track.audioFeatures?.loudnessString ?? "–")
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
                if showingColumn.columns[6].showing {
                    Text(track.audioFeatures?.instrumentalnessString ?? "–")
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
            }
            Group {
                if showingColumn.columns[7].showing {
                    Text(track.audioFeatures?.acousticnessString ?? "–")
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
                if showingColumn.columns[8].showing {
                    Text(track.audioFeatures?.livelinessString ?? "–")
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
            }
            Group {
                if showingColumn.columns[9].showing {
                    Text(track.spotifyItem?.popularityString ?? "–")
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
                if showingColumn.columns[10].showing {
                    Text(track.appleMusicItem?.genres.joined(separator: ", ") ?? "–")
                        .font(statsFont)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable) + 35)
                }
                if showingColumn.columns[11].showing {
                    Text(track.spotifyItem?.year?.description ?? "–")
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
            }
        }
    }
    
    
}

struct NewTrackView_Previews: PreviewProvider {
    
    static var previews: some View {
        TracksRowView(track: MockData.trackWithFeatures, showingColumn: ColumnsShowing(), widthOfTable: 800)
        .frame(minWidth: 800)
        .environmentObject(PlayerManager())
    }
}
