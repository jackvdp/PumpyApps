//
//  ScheduleView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 26/09/2019.
//  Copyright © 2019 Jack Vanderpump. All rights reserved.
//

import UIKit
import MediaPlayer

@objcMembers
class ScheduleView: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView!
   
    let viewController = ViewController()
    let musicPlayerManager = MusicPlayerManager()
    var currentArtwork: MPMediaItemArtwork!
    
    override func viewDidLoad() {
        updateBG()
        NotificationCenter.default.addObserver(self,
        selector: #selector(handleMusicPlayerManagerDidUpdateState),
        name: MusicPlayerManager.didUpdateState,
        object: nil)
    }
    
    // MARK: Buttons
    
    
    
    // MARK: Functions

    func updateBG() {
                if let nowPlayingItem = musicPlayerManager.musicPlayerController.nowPlayingItem {
                    currentArtwork = nowPlayingItem.artwork
                    backgroundView.image = currentArtwork.image(at: backgroundView.frame.size)
                } else {
                    backgroundView.image = .init(imageLiteralResourceName: "Pumpy Artwork")
                }
            }
        
    // MARK: Notification Observing Methods
    
    func handleMusicPlayerManagerDidUpdateState() {
        DispatchQueue.main.async {
            self.updateBG()
        }
    }
    
    
}
