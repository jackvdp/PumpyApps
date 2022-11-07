//
//  Music Extensions.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 06/08/2022.
//  Copyright © 2022 Jack Vanderpump. All rights reserved.
//

import Foundation
import MediaPlayer
import PumpyLibrary

extension MPMusicPlayerApplicationController {
    
    open override func prepend(_ descriptor: MPMusicPlayerQueueDescriptor) {
        super.prepend(descriptor)
        let nc = NotificationCenter.default
        nc.post(name: .MPMusicPlayerControllerQueueDidChange, object: MPMusicPlayerController.applicationQueuePlayer)
    }
}


extension MusicManager {
    func addMusicObserver(for notificatioName: NSNotification.Name, action: Selector) {
        NotificationCenter.default.addObserver(self,
                                               selector: action,
                                               name: notificatioName,
                                               object: musicPlayerController)
    }
    func removeMusicObserver(for notificatioName: NSNotification.Name) {
        NotificationCenter.default.removeObserver(self,
                                                  name: notificatioName,
                                                  object: musicPlayerController)
    }
    
    func removeMusicObservers(for notificationsName: [NSNotification.Name]) {
        for notificatioName in notificationsName {
            removeMusicObserver(for: notificatioName)
        }
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
