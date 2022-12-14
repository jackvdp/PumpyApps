//
//  Apple Music API.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 05/03/2022.
//

import Foundation
import Alamofire
import StoreKit
import SwiftyJSON

class AMTracksAPI {
    
    func getAppleItemFromISRCs(isrcs: String, authManager: AuthorisationManager, completion: @escaping ([AppleMusicItem])->()) {
        let storefront = authManager.storefront ?? "gb"

        let url = "https://api.music.apple.com/v1/catalog/\(storefront)/songs?filter[isrc]=\(isrcs)"
        let header = HTTPHeaders([HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken)])
        
        AF.request(url, headers: header).response { res in
            guard let data = res.data else {
                completion([])
                return
            }
            
            if res.response?.statusCode == 429 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.getAppleItemFromISRCs(isrcs: isrcs, authManager: authManager, completion: completion)
                }
            } else {
                let items = AMTrackParser().convertISRCFilterToItems(data)
                completion(items)
            }
        }
    }
    
    func searchForID(formattedTrackForSearch: String, authManager: AuthorisationManager, completion: @escaping ([AppleMusicItem])->()) {
        guard let storefront = authManager.storefront else {
            completion([])
            return
        }
        
        let typeQueryItem = URLQueryItem(name: "types", value: "songs")
        let termQueryItem = URLQueryItem(name: "term", value: formattedTrackForSearch)

        var urlComponents = URLComponents()
        urlComponents.queryItems = [typeQueryItem, termQueryItem]
        
        let url = "https://api.music.apple.com/v1/catalog/\(storefront)/search/\(urlComponents)"
        let header = HTTPHeaders([HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken)])
        
        AF.request(url, headers: header).response { res in
            guard let data = res.data else { return }
            if res.response?.statusCode == 429 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.searchForID(formattedTrackForSearch: formattedTrackForSearch,
                                     authManager: authManager,
                                     completion: completion)
                }
            } else {
                let items = AMTrackParser().convertSearchToItems(data)
                completion(items)
            }
        }
    }

}
