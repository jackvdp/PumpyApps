//
//  StationsGateway.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 11/08/2023.
//

import Foundation
import Alamofire

class GetStationGateway {
    
    func get(stationID: String,
             authManager: AuthorisationManager) async -> (code: Int?, station: Stations?) {
        
        guard let userToken = authManager.appleMusicToken else { return (401, nil) }
        
        let url = "https://api.music.apple.com/v1/catalog/gb/stations/\(stationID)"
        
        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken),
            HTTPHeader(name: K.MusicStore.musicUserToken, value: userToken)
        ])
        
        let response = await AF.request(url,
                                        method: .get,
                                        headers: headers).serializingDecodable(Stations.self).response
        return(response.response?.statusCode, response.value)
    }
    
}

class GetStationTracksGateway {
    
    func post(stationID: String,
              authManager: AuthorisationManager) async -> (code: Int?, tracks: StationTracks?) {
        
        guard let userToken = authManager.appleMusicToken else { return (401, nil) }
        
        let url = "https://api.music.apple.com/v1/me/stations/next-tracks/\(stationID)?limit=10"
        
        let headers = HTTPHeaders([
            HTTPHeader(name: K.MusicStore.authorisation, value: K.MusicStore.bearerToken),
            HTTPHeader(name: K.MusicStore.musicUserToken, value: userToken)
        ])
        
        let response = await AF.request(url,
                                        method: .post,
                                        headers: headers).serializingDecodable(StationTracks.self).response
        guard let value = response.value else {
            print(response.error)
            print(response.response?.statusCode)
            return (400, nil)
        }
        
        return(response.response?.statusCode, response.value)
        
    }
    
}
