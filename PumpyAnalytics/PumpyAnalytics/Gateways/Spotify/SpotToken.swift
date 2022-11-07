//
//  SpotifyTokenParser.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 01/03/2022.
//

import Foundation
import SwiftyJSON

class SpotifyTokenAPI {
    
    func getSpotifyToken(clientID: String, clientSecret: String, completion: @escaping (String?, Int) -> ()) {
        if let musicURL = URL(string: "https://accounts.spotify.com/api/token") {
            let body = String("grant_type=client_credentials").data(using: .utf8)
            var musicRequest = URLRequest(url: musicURL)
            musicRequest.httpMethod = "POST"
            
            let headerValue = String("\(clientID):\(clientSecret)").toBase64()
            
            musicRequest.addValue("Basic \(headerValue)", forHTTPHeaderField: K.MusicStore.authorisation)
            musicRequest.httpBody = body
            
            URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
                guard error == nil else { return }
                if let d = data {
                    let tokenAndTime = self.parseToken(data: d)
                    if let token = tokenAndTime.0, let time = tokenAndTime.1 {
                        completion(token, time)
                    }
                }
            }.resume()
        }
    }
    
    private func parseToken(data: Data) -> (String?, Int?){
        if let jsonData = try? JSON(data: data) {
            if let token = jsonData["access_token"].string {
                let spotifyToken = token
                let renewTime = jsonData["expires_in"].int ?? 130
                return (spotifyToken, renewTime)
            }
        }
        return (nil, nil)
    }
    
}
