//
//  SpotifyMusicRequest.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 17/03/2022.
//

import Foundation
import Alamofire

class SpotifyComponents {
    
    func request(_ url: URL, token: String) -> URLRequest {
        var musicRequest = URLRequest(url: url)
        musicRequest.httpMethod = "GET"
        musicRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return musicRequest
    }
    
    func retry(response: AFDataResponse<Data?>, completion: @escaping () -> ()) {
        let retryIn = response.response?.headers.dictionary["retry-after"]
        let retryInt = Int(retryIn ?? "2") ?? 2
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(retryInt)) {
            completion()
        }
    }
    
    func retryAsync(response: DataResponse<Data, AFError>) async {
        let retryIn = response.response?.headers.dictionary["retry-after"]
        let retryInt = Int(retryIn ?? "2") ?? 2
        let nanoseconds = UInt64(retryInt) * 1_000_000_000
        try? await Task.sleep(nanoseconds: nanoseconds)
    }
    
}
