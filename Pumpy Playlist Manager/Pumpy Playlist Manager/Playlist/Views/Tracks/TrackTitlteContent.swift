//
//  TrackTitlteContent.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 31/10/2022.
//

import SwiftUI
import PumpyAnalytics

struct TracksTitleContent: View {
    
    @ObservedObject var track: Track
    @State private var isHovering = false
    
    var body: some View {
        HStack(spacing: 10) {
            artwork
            songDescription
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var artwork: some View {
        AsyncImage(url: URL(string: track.artworkURL?.getArtworkURLForSize(40) ?? "")) { image in
            image
                .resizable()
        } placeholder: {
            Image(K.Images.pumpyArtwork)
                .resizable()
        }
        .onHover(perform: { isHovering in
            self.isHovering = isHovering
        })
        .overlay (
            track.previewUrl != nil ? HoveringView(isHovering: $isHovering, track: track) : nil
        )
        .background(Color.black)
        .cornerRadius(5)
        .frame(width: 40, height: 40)
    }
    
    var songDescription: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(track.title)
                    .lineLimit(1)
                Image(systemName: "e.square.fill")
                    .opacity(0.5)
                    .font(.subheadline)
                    .opacity(track.isExplicit ? 1:0)
            }
            Text(track.artist)
                .lineLimit(1)
                .font(.subheadline)
                .opacity(0.5)
        }
    }
}

struct TrackTitlteContent_Previews: PreviewProvider {
    static var previews: some View {
        TracksTitleContent(track: MockData.trackWithFeatures)
            .environmentObject(PlayerManager())
    }
}
