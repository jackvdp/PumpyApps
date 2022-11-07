//
//  StatsNotifcation.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 16/03/2022.
//

import Foundation

struct StatsNotification {
    
    func post() {
        NotificationCenter.default.post(
            name: .TracksGotAnalysed,
            object: nil
        )
    }
    
}

struct MatchNotification {

    func post() {
        NotificationCenter.default.post(
            name: .TracksMatchedToAppleMusic,
            object: nil
        )
    }
    
}

extension Notification.Name {
    public static var TracksMatchedToAppleMusic = Notification.Name("TrackGotStats")
    public static var TracksGotAnalysed = Notification.Name("TracksGotAnalysed")
}
