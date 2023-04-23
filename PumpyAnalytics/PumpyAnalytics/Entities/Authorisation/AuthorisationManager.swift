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
    
    @Published public var spotifyToken: String?
    @Published public var appleMusicToken: String?
    @Published public var storefront: String?
    
    public var appleTokenCompletion: ((String) -> ())?
    public var spotifyTokenCompletion: ((String) -> ())?

    public init() {}
    
    deinit {
        print("deiniting AM")
    }
    
    /// Call to get tokens. Should be called on start.
    public func fetchTokens() {
        getSpotifyToken()
        checkIfAuthorised()
        getStoreFrontID()
    }
    
    // MARK: - Spotify
    
    private let spotifyAPI = SpotifyTokenAPI()
    private var renewTokenTimer: Timer?
    
    public func getSpotifyToken() {
        spotifyAPI.getSpotifyToken(clientID: K.Spotify.clientID,
                                   clientSecret: K.Spotify.clientSecret) { [weak self] token, renewTime in
            guard let self else { return }
            print("Spotify Token: " + (token ?? "N/A"))
            DispatchQueue.main.async {
                self.spotifyToken = token
                self.renewToken(time: renewTime)
                self.spotifyTokenCompletion?(token ?? "")
            }
        }
    }
    
    private func renewToken(time: Int) {
        renewTokenTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(time-60), repeats: false) { [weak self] timer in
            self?.getSpotifyToken()
        }
    }
    
    public func removeTimer() {
        renewTokenTimer?.invalidate()
        renewTokenTimer = nil
    }
    
    // MARK: - AM

    private let storeController = SKCloudServiceController()
    
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
                self.appleTokenCompletion?(token)
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

}
