//
//  TrackArtworkView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 08/10/2022.
//

import SwiftUI

public struct ArtworkView: View {
    public init(artworkURL: String? = nil, size: CGFloat? = nil) {
        self.artworkURL = artworkURL
        self.size = max(1, size ?? 0)
    }
    
    let artworkURL: String?
    let size: CGFloat?
    @State private var measureRect = CGRect()
    
    public var body: some View {
        artwork
            .background(GeometryGetter(rect: $measureRect))
            .cornerRadius((size ?? measureRect.width) / 12)
            .frame(width: size, height: size)
            .aspectRatio(1, contentMode: .fit)
            .shadow(color: .black.opacity(0.5),
                    radius: 10, x: 5, y: 5)
    }
    
    private var artwork: some View {
        AsyncImage(url: formatArtwork(artworkURL, size: size ?? measureRect.width),
                   transaction: .init(animation: .easeIn)) { phase in
            switch phase {
            case .success(let image):
                image.resizable()
            default:
                defaultImage(width: size ?? measureRect.width)
            }
        }
    }
    
    public var background: some View {
        ZStack {
            artwork
                .blur(radius: 100)
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.6)
        }
        .edgesIgnoringSafeArea(.all)
    }

    func defaultImage(width: CGFloat) -> some View {
        ZStack {
            LinearGradient(gradient: gradient,
                           startPoint: .top,
                           endPoint: .bottom)
            Image(systemName: "music.note")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: width / 3)
        }
    }

    var gradient = Gradient(colors: [
        .black, .pumpyBlue, .pumpyPurple,
    ])
    
    private func formatArtwork(_ artworkURL: String?, size: CGFloat) -> URL? {
        guard let artworkURL else { return nil }
        return ArtworkHandler.makeMusicStoreURL(artworkURL, size: Int(size))
    }
    
}
struct TrackArtworkView_Previews: PreviewProvider {
    
    static var previews: some View {
        HStack {
            ArtworkView(artworkURL: MockData.track.artworkURL ?? "",
                             size: 100)
                .preferredColorScheme(.dark)
            Text("Hey")
                .layoutPriority(1)
            Spacer()
        }
        .frame(width: 300, height: 100)
        .border(Color.blue)
    }
}
