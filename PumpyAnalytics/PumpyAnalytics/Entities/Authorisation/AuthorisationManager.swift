//
//  AuthorisationManager.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 27/02/2022.
//

import Foundation
import SwiftyJSON
import StoreKit

public class AuthorisationManager: ObservableObject {
    
    private let clientID = K.Spotify.clientID
    private let clientSecret = K.Spotify.clientSecret
    private var renewTokenTimer: Timer?
    @Published public var spotifyToken: String?
    @Published public var appleMusicToken: String?
    @Published public var storefront: String?
    let storeController = SKCloudServiceController()
    
    public init() {}
    
    public func fetchTokens() {
        getSpotifyToken()
        checkIfAuthorised()
        getStoreFrontID()
    }
    
    // MARK: - Spotify
    
    public func getSpotifyToken() {
        SpotifyTokenAPI().getSpotifyToken(clientID: clientID, clientSecret: clientSecret) { token, renewTime in
            print("Spotify Token: " + (token ?? "N/A"))
            DispatchQueue.main.async {
                self.spotifyToken = token
            }
            self.renewToken(time: renewTime)
        }
    }
    
    private func renewToken(time: Int) {
        print(time)
        renewTokenTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(time-60), repeats: false) { timer in
            self.getSpotifyToken()
        }
    }
    
    // MARK: - AM

    public func checkIfAuthorised() {
        SKCloudServiceController.requestAuthorization { status in
            self.getAppleMusicToken()
        }
    }
    
    public func getAppleMusicToken() {
        storeController.requestUserToken(forDeveloperToken: K.MusicStore.developerToken) { (receivedToken, error) in
            guard error == nil else {
                print(error.debugDescription)
                return
            }
            if let token = receivedToken {
                print("Am Token: " + token)
                self.appleMusicToken = token
            }
        }
    }
    
    public func getStoreFrontID() {
        storeController.requestStorefrontCountryCode { store, error in
            if let e = error {
                print(e)
            } else {
                if let store = store {
                    print(store)
                    self.storefront = store
                }
            }
        }
    }
    
}
