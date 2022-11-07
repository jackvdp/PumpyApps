//
//  AlbumAPI.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 19/09/2022.
//

import Foundation
import Alamofire
import MusicKit

class AlbumGateway: AlbumGatewayProtocol {
    
    func get(id: String, authManager: AuthorisationManager, completion: @escaping (AMAlbumBoundary?, Int)->()) {

        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken)
        ])
        
        let storefront = authManager.storefront ?? "gb"
        
        let url = "https://api.music.apple.com/v1/catalog/\(storefront)/albums/\(id)?include=tracks"
        
        AF.request(url, headers: headers).responseDecodable(of: AMAlbumBoundary.self) { response in
            print(id)
            completion(response.value, response.response?.statusCode ?? 400)
        }
        
    }
    
}

protocol AlbumGatewayProtocol {
    func get(id: String, authManager: AuthorisationManager, completion: @escaping (AMAlbumBoundary?, Int)->())
}
