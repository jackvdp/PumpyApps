//
//  NewTracksView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/06/2022.
//

import SwiftUI
import PumpyAnalytics

struct TracksView: View {
    
    let tracks: [Track]
    var deleteAction: ((Set<Track>) -> ())?
    @State private var selection = Set<Track>()
    @ObservedObject var columnsShowing: ColumnsShowing
    
    var body: some View {
        GeometryReader { geo in
            List(selection: $selection) {
                Section(header: TracksHeaderView(showingColumn: columnsShowing, widthOfTable: geo.size.width)) {
                    ForEach(tracks, id: \.self) { track in
                        TracksRowView(track: track, showingColumn: columnsShowing, widthOfTable: geo.size.width)
                            .contextMenu{
                                TrackContextMenu(tracks: Array(selection),
                                                 currentTrack: track,
                                                 deleteAction: deleteTracks)
                            }
                    }
                }
            }
            .listStyle(.bordered(alternatesRowBackgrounds: true))
        }
        
    }
    
    func deleteTracks() {
        if let deleteAction = deleteAction {
            deleteAction(selection)
            selection = Set<Track>()
        }
    }
}

struct NewTracksView_Previews: PreviewProvider {
    static var previews: some View {
        TracksView(tracks: [MockData.trackWithFeatures,
                            MockData.secondTrackWithFeatures,
                                               MockData.thirdTrack],
                   columnsShowing: ColumnsShowing())
            .environmentObject(PlayerManager())
            .frame(width: 1000)
    }
}
