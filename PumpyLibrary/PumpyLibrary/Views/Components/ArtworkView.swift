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
    
    public init(artworkURL: String? = nil,
                size: CGFloat? = nil,
                backgroundColour: Binding<UIColor?> = .constant(nil),
                colourCallback: ((UIColor?) -> ())? = nil) {
        self.artworkURL = artworkURL
        self.size = max(1, size ?? 1)
        self._backgroundColour = backgroundColour
        self.colourCallback = colourCallback
    }
    
    let artworkURL: String?
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
        if artworkURL != nil {
            KFImage(formatArtwork(artworkURL, size: size))
                .cancelOnDisappear(true)
                .fade(duration: 0.25)
                .placeholder { _ in
                    defaultImage
                }
                .onSuccess({ result in
                    backgroundColour = result.image.averageColor
                    colourCallback?(result.image.averageColor)
                })
                .onFailure({ error in
                    backgroundColour = nil
                })
                .resizable()
        } else {
            defaultImage
        }
    }

    var defaultImage: some View {
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
    }

    private var gradient = Gradient(colors: [
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

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}
