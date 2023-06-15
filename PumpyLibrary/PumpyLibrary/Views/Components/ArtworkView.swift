//
//  TrackArtworkView.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 08/10/2022.
//

import SwiftUI
import Kingfisher
import MediaPlayer

public struct ArtworkView: View {
    
    public init(collection: MusicCollection? = nil,
                size: CGFloat? = nil,
                backgroundColour: Binding<UIColor?> = .constant(nil),
                colourCallback: ((UIColor?) -> ())? = nil) {
        self.collection = collection
        self.size = max(1, size ?? 1)
        self._backgroundColour = backgroundColour
        self.colourCallback = colourCallback
    }
    
    public init(url: String? = nil,
                size: CGFloat? = nil,
                backgroundColour: Binding<UIColor?> = .constant(nil),
                colourCallback: ((UIColor?) -> ())? = nil) {
        self.collection = ArtworkCollection(url)
        self.size = max(1, size ?? 1)
        self._backgroundColour = backgroundColour
        self.colourCallback = colourCallback
    }
    
    let collection: MusicCollection?
    let size: CGFloat
    @Binding var backgroundColour: UIColor?
    var colourCallback: ((UIColor?) -> ())?
    
    public var body: some View {
        artwork
            .cornerRadius(size / 12)
            .frame(width: size, height: size)
            .aspectRatio(1, contentMode: .fit)
            .shadow(color: .black.opacity(0.5),
                    radius: 10, x: 5, y: 5)
    }
    
    @ViewBuilder
    private var artwork: some View {
        if let url = collection?.artworkURL {
            artwork(fromURL: url)
        } else if let mpArtworkImage = attemptFetchImageOfMPArtwork() {
            artwork(fromMediaPlayer: mpArtworkImage)
        } else {
            artworkDefault
        }
    }
    
    private func artwork(fromMediaPlayer image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .onAppear() {
                setBackgroundColour(image)
            }
    }
    
    private func artwork(fromURL url: String) -> some View {
        KFImage(formatArtwork(url, size: size))
            .cancelOnDisappear(true)
            .fade(duration: 0.25)
            .placeholder { _ in
                artworkDefault
            }
            .onSuccess({ result in
                setBackgroundColour(result.image)
            })
            .onFailure({ error in
                setBackgroundColour(nil)
            })
            .resizable()
    }

    private var artworkDefault: some View {
        ZStack {
            LinearGradient(gradient: gradient,
                           startPoint: .top,
                           endPoint: .bottom)
            Image(systemName: "music.note")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: size / 3)
        }
        .onAppear() {
            backgroundColour = nil
            colourCallback?(nil)
        }
    }

    private var gradient = Gradient(colors: [
        .black, .pumpyBlue, .pumpyPurple,
    ])
    
    // MARK: - Methods
    
    private func formatArtwork(_ artworkURL: String?, size: CGFloat) -> URL? {
        guard let artworkURL else { return nil }
        return ArtworkHandler.makeMusicStoreURL(artworkURL, size: Int(size))
    }
    
    private func attemptFetchImageOfMPArtwork() -> UIImage? {
        (collection as? MPMediaItem)?
            .artwork?
            .image(at: CGSize(width: size, height: size)) ??
        (collection as? MPMediaPlaylist)?
            .artwork
    }
    
    private func setBackgroundColour(_ image: UIImage?) {
        let colour = image?.averageColor
        backgroundColour = colour
        colourCallback?(colour)
    }
}

// MARK: Extensions

/// A simple struct to allow ArtworkView to accept only a url
private struct ArtworkCollection: MusicCollection {
    init(_ url: String?) {
        artworkURL = url
    }
    var artworkURL: String?
}

// MARK: - Preview

struct TrackArtworkView_Previews: PreviewProvider {
    
    static var previews: some View {
        HStack {
            ArtworkView(collection: MockData.track,
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
