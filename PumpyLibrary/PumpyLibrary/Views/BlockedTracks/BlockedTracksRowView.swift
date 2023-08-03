//
//  BlockedTracksRowView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/08/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct BlockedTracksRowView: View {
    
    let track: BlockedTrack
    
    var body: some View {
        HStack(alignment: .center, spacing: 20.0) {
            ArtworkView(collection: track, size: 60)
            VStack(alignment: .leading, spacing: 5.0) {
                HStack(alignment: .center, spacing: 10.0) {
                    Text(track.title)
                        .font(.headline)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    if track.isExplicit {
                        Image(systemName: "e.square")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 12, height: 12, alignment: .center)
                    }
                }
                Text(track.artist)
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
        }
        .padding(.all, 5.0)
    }
}

struct BlockedTracksRowView_Previews: PreviewProvider {
    static var previews: some View {
        BlockedTracksRowView(
            track: MockData.track.getBlockedTrack()!
        )
    }
}
