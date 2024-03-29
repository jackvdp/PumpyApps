//
//  ItemGridComponent.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 15/09/2022.
//

import SwiftUI

struct ItemGridComponent: View {
    let name: String
    let curator: String
    let itemArtworkURL: String
    let size: Int
    var font: Font = Font.callout
    
    var body: some View {
        VStack(alignment: .leading) {
            artwork
            text.frame(width: CGFloat(size - 50))
        }
    }
    
    var artwork: some View {
        ArtworkView(url: itemArtworkURL,
                    size: CGFloat(size - 50))
    }
    
    var text: some View {
        VStack(alignment: .leading) {
            Text(name)
            Text(curator)
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(font.bold())
        .lineLimit(1)
    }

}

#if DEBUG
struct ItemGridComponent_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            ItemGridComponent(name: MockData.track.name,
                              curator: MockData.track.artistName,
                              itemArtworkURL: MockData.track.artworkURL ?? "",
                              size: 300)
            .frame(height: 300)
            .border(.red)
            ItemGridComponent(name: MockData.track.name,
                              curator: MockData.track.artistName,
                              itemArtworkURL: MockData.track.artworkURL ?? "",
                              size: 200)
            .frame(height: 200)
            .border(.red)
        }
    }
}
#endif
