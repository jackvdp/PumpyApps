//
//  AppleMusicParser.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 24/03/2022.
//

import Foundation
import SwiftyJSON

class AMTrackParser {
    
    func convertISRCFilterToItems(_ data: Data) -> [AppleMusicItem] {
        guard let json = try? JSON(data: data) else {
            print("Didn't get data whilst matching: \(data)")
            return []
        }
        guard let jsonArray = json["data"].array else {
            print("Didn't get array whilst matching: \(json)")
            return []
        }

        return converDataArray(jsonArray)
    }
    
    func convertSearchToItems(_ data: Data) -> [AppleMusicItem] {
        guard let json = try? JSON(data: data) else {
            print("Didn't get data: \(data)")
            return []
        }
        
        guard let jsonArray = json["results"]["songs"]["data"].array else {
            print("Didn't get array: \(json)")
            return []
        }

        return converDataArray(jsonArray)
    }
    
    private func converDataArray(_ jsonArray: [JSON]) -> [AppleMusicItem] {
        return jsonArray.compactMap { jsonItem in
            
            guard let id = jsonItem["id"].string else {
                print("Didn't get music item whilst matching: \(jsonArray)")
                return nil
            }
            
            guard let isrc = jsonItem["attributes"]["isrc"].string else {
                print("Didn't get isrc when finding music item whilst matching: \(jsonArray)")
                return nil
            }
            
            let name = jsonItem["attributes"]["name"].string ?? ""
            let artist = jsonItem["attributes"]["artistName"].string ?? ""
            let artworkURL = jsonItem["attributes"]["artwork"]["url"].string
            let genres = jsonItem["attributes"]["genreNames"].array
            
            var genreStrings = [String]()
            for genre in (genres ?? [JSON]()) {
                if let genreString = genre.string {
                    if genreString != "Music" {
                        genreStrings.append(genreString)
                    }
                }
            }
            
            return AppleMusicItem(isrc: isrc,
                                  id: id,
                                  name: name,
                                  artistName: artist,
                                  artworkURL: artworkURL,
                                  genres: genreStrings,
                                  type: .track)
        }
    }
    
}

