//
//  Constants.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 03/01/2020.
//  Copyright © 2020 Jack Vanderpump. All rights reserved.
//

import Foundation

public struct K {
    
    public static let versionNumber = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    public static let pumpyPink = "pumpyPink"
    public static let username = "Username"
    public static let password = "Password"
    public static let alarmsKey = "alarmsKey"
    public static let repeatKey = "repeatItem"
    public static let didUpdateStateNotification = NSNotification.Name("didUpdateState")
    public static let pumpyImage = "Pumpy Logo Transparent"
    public static let stopMusic = "Stop Music"
    public static let defaultArtwork = "Pumpy Artwork"
    
    public struct Alarm {
        public static let playlistLabel = "playlistLabel"
        public static let secondaryAlarm = "secondaryAlarm"
        public static let externalSettingsOverride = "externalSettingsOverride"
        public static let showQRCode = "showQRCode"
        public static let qrLink = "QRLink"
        public static let qrMessage = "QRMessage"
        public static let contentType = "contentType"
        public static let messageSpeed = "messageSpeed"
        public static let qrType = "qrType"
    }
    
    public struct FStore {
        public static let FCMKey = "AIzaSyB388XOkRSDcSZzXQ54ql3EsdRtjF0lAuE"
        public static let alarmCollection = "Alarm Collection"
        public static let currentPlayback = "Latest Playback Info"
        public static let remoteData = "Remote Data"
        public static let playlistCollection = "Playlist Collection"
        public static let trackCollection = "Track Collection"
        public static let upNext = "Up Next"
        public static let playlistName = "Playlist Name"
        public static let activeStatus = "Active Status"
        public static let settings = "Settings"
        public static let extDisSettings = "External Display Settings"
        public static let repeatShowing = "Repeat Showing"
        public static let repeatTrack = "Repeat Track"
        public static let downloadedTracks = "Downloaded Tracks"
        public static let blockedTracks = "Blocked Tracks"
        public static let time = "Time"
        public static let deviceName = "Device Name"
    }
    
    public struct MusicStore {
        public static let url = "https://api.music.apple.com/v1/"
        public static let musicUserToken = "Music-User-Token"
        public static let authorisation = "Authorization"
        public static let bearerToken = "Bearer \(K.MusicStore.developerToken)"
    }

    public struct Font {
        public static let helvetica = "HelveticaNeue"
        public static let helveticaLight = "HelveticaNeue-Light"
    }
}
