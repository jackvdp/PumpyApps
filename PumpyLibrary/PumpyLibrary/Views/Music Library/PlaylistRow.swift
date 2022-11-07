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
            ArtworkView(artworkURL: playlist.artworkURL, size: 75)
            Text(playlist.name ?? "")
                .font(.headline)
        }
        .padding(.all, 10.0)
    }
}

struct PlaylistRow_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistRow(playlist: MockData.playlist)
    }
}
