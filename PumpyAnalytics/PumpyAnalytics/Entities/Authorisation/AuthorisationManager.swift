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
    private let storeController = SKCloudServiceController()
    @Published public var spotifyToken: String?
    @Published public var appleMusicToken: String?
    @Published public var storefront: String?
    
    public init() {}
    
    deinit {
        print("deiniting AM")
    }
    
    public func fetchTokens() {
        getSpotifyToken()
        checkIfAuthorised()
        getStoreFrontID()
    }
    
    // MARK: - Spotify
    
    let spotifyAPI = SpotifyTokenAPI()
    
    public func getSpotifyToken() {
        spotifyAPI.getSpotifyToken(clientID: clientID, clientSecret: clientSecret) { [weak self] token, renewTime in
            guard let self else { return }
            print("Spotify Token: " + (token ?? "N/A"))
            DispatchQueue.main.async {
                self.spotifyToken = token
            }
            self.renewToken(time: renewTime)
        }
    }
    
    private func renewToken(time: Int) {
        renewTokenTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(time-60), repeats: false) { [weak self] timer in
            self?.getSpotifyToken()
        }
    }
    
    // MARK: - AM

    public func checkIfAuthorised() {
        SKCloudServiceController.requestAuthorization { [weak self] status in
            self?.getAppleMusicToken()
        }
    }
    
    public func getAppleMusicToken() {
        storeController.requestUserToken(forDeveloperToken: K.MusicStore.developerToken) { [weak self] (receivedToken, error) in
            guard let self else { return }
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
        storeController.requestStorefrontCountryCode { [weak self] store, error in
            guard let self else { return }
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
    
    public func removeTimer() {
        renewTokenTimer?.invalidate()
        renewTokenTimer = nil
    }
}
