//
//  UIImage+averageColor.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 13/06/2023.
//

import UIKit
import MediaPlayer

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

extension MPMediaPlaylist {
    /**
     User selected image for playlist stored on disk.
     */
    public var artwork: UIImage? {
        guard let catalog = value(forKey: "artworkCatalog") as? NSObject else {
            return nil
        }

        let sel = NSSelectorFromString("bestImageFromDisk")

        guard catalog.responds(to: sel),
            let value = catalog.perform(sel)?.takeUnretainedValue(),
            let image = value as? UIImage else {
            return nil
        }
        return image
    }

    /**
     URL for playlist's image.
     */
    public var artworkURL: String? {
        if let catalog = value(forKey: "artworkCatalog") as? NSObject,
            let token = catalog.value(forKey: "token") as? NSObject,
            let url = token.value(forKey: "availableArtworkToken") as? String ??
                        token.value(forKey: "fetchableArtworkToken") as? String {
            if url.contains("https:") {
                return url.replacingOccurrences(of: "600x600", with: "{w}x{w}")
            } else {
                return "https://is3-ssl.mzstatic.com/image/thumb/\(url)/{w}x{w}cc.jpg"
            }
        }
        return nil
    }
    
}
