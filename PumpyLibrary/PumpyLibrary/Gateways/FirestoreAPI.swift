//
//  FirestoreAPI.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 06/10/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import Foundation
import UIKit

class FirestoreAPI {
    
    static func setPlaybackItem(username: String, playbackItem: PlaybackItem) {
        
        let urlString = "https://firestore.googleapis.com/v1/projects/pumpy-music-ios/databases/(default)/documents/\(username)/Latest%20Playback%20Info"
        let playbackState = playbackItem.playbackState
        let playlistName = playbackItem.playlistName
        let queueIndex = playbackItem.queueIndex
        let trackArtistName = playbackItem.trackArtistName
        let trackName = playbackItem.trackName
        let updateTime = playbackItem.updateTime
        let versionNumber = playbackItem.versionNumber
        let itemID = playbackItem.itemID
        
        if let url = NSURL(string: urlString) {
            
            let paramString: [String : Any] = [
                "fields": [
                    "Latest Playback Info": [
                        "mapValue": [
                            "fields": [
                                "itemID": [
                                    "stringValue": itemID
                                ],
                                "playbackState": [
                                    "integerValue": playbackState
                                ],
                                "playlistName": [
                                    "stringValue": playlistName
                                ],
                                "queueIndex": [
                                    "integerValue": queueIndex
                                ],
                                "trackArtistName": [
                                    "stringValue": trackArtistName
                                ],
                                "trackName": [
                                    "stringValue": trackName
                                ],
                                "updateTime": [
                                    "stringValue": updateTime
                                ],
                                "versionNumber": [
                                    "stringValue": versionNumber
                                ]
                            ]
                        ]
                    ]
                ]
            ]
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "PATCH"
            request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                if let e = error {
                    print("Error \(e)")
                } else {
                    print("Success BITCHES")
                    do {
                        if let jsonData = data {
                            if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                                NSLog("Received data:\n\(jsonDataDict))")
                            }
                        }
                    } catch let err as NSError {
                        print(err.debugDescription)
                    }
                }
            }
            task.resume()
            
        } else {
            print("Not valid")
        }
        
    }
    
}
