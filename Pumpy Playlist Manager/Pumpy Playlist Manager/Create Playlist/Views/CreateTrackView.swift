//
//  CreateTrackView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/06/2022.
//

import SwiftUI
import PumpyAnalytics

struct CreateTrackView: View {
    
    let track: Track
    @State private var isHovering = false
    let height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: track.artworkURL?.getArtworkURLForSize(Int(height * 2)) ?? "")) { image in
                image
                    .interpolation(.none)
                    .resizable()
            } placeholder: {
                Image(K.Images.pumpyArtwork)
                    .resizable()
            }
            .aspectRatio(1, contentMode: .fill)
            .frame(height: (height - 32) * 2)
            .cornerRadius(10)
            .clipped()
            .onHover(perform: { isHovering in
                self.isHovering = isHovering
            })
            .overlay (
                track.previewUrl != nil ? HoveringView(isHovering: $isHovering, playSize: (height - 32) * 0.5, track: track) : nil
            )
            Text(track.title)
                .lineLimit(1)
                .layoutPriority(1)
            Text(track.artist)
                .lineLimit(2)
                .opacity(0.5)
                .layoutPriority(1)
        }
        .padding()
        .buttonStyle(.plain)
        .contextMenu {
            TrackContextMenu(tracks: [], currentTrack: track)
        }
        .frame(maxWidth: 250)
    }
}

struct CreateTrackView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTrackView(track: MockData.track, height: 200)
            .environmentObject(CreateManager())
            .environmentObject(PlayerManager())
    }
}
