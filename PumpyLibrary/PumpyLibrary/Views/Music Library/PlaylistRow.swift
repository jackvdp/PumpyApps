//
//  PlaylistRow.swift
//  PlaylistPicker
//
//  Created by Jack Vanderpump on 30/11/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct PlaylistRow : View {

    let playlist: Playlist
    
    var body: some View {
        HStack(alignment: .center, spacing: 20.0) {
            ArtworkView(collection: playlist, size: 75)
            VStack(alignment: .leading, spacing: 5) {
                Text(playlist.title ?? "Playlist")
                    .font(.headline)
                if playlist.curator != "" {
                    Text(playlist.curator)
                        .font(.subheadline)
                        .opacity(0.5)
                }
            }
        }
        .padding(.all, 10.0)
    }
}

struct PlaylistRow_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistRow(playlist: MockData.playlist)
    }
}
