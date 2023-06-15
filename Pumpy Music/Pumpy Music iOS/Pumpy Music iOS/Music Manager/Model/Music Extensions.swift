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
