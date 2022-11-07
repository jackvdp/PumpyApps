//
//  MockAlbumGateway.swift
//  PumpyAnalyticsTests
//
//  Created by Jack Vanderpump on 19/09/2022.
//

import Foundation
@testable import PumpyAnalytics
import MusicKit

class MockAlbumGateway: AlbumGatewayProtocol {
    func get(id: String, authManager: AuthorisationManager, completion: @escaping (AMAlbumBoundary?, Int) -> ()) {
        let model = albumJSON.convertJSONStringToModel(to: AMAlbumBoundary.self)
        completion(model, 200)
    }

}

private let albumJSON =
"""
{
    "data": [
        {
            "id": "1541357258",
            "type": "albums",
            "href": "/v1/catalog/gb/albums/1541357258",
            "attributes": {
                "copyright": "℗ 2020 RCA Records, a division of Sony Music Entertainment",
                "genreNames": [
                    "Pop",
                    "Music"
                ],
                "releaseDate": "2020-12-04",
                "isMasteredForItunes": false,
                "upc": "886448814054",
                "artwork": {
                    "width": 3000,
                    "height": 3000,
                    "url": "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/01/e3/ee/01e3ee21-e857-739d-7673-7235bb87961b/886448814054.jpg/{w}x{h}bb.jpg",
                    "bgColor": "11141e",
                    "textColor1": "c9cbd2",
                    "textColor2": "b2bacc",
                    "textColor3": "a4a6ad",
                    "textColor4": "9299a9"
                },
                "url": "https://music.apple.com/gb/album/swimming-in-the-stars-single/1541357258",
                "playParams": {
                    "id": "1541357258",
                    "kind": "album"
                },
                "recordLabel": "RCA Records Label",
                "isCompilation": false,
                "trackCount": 1,
                "isSingle": true,
                "name": "Swimming In The Stars - Single",
                "artistName": "Britney Spears",
                "editorialNotes": {
                    "standard": "A rarity from the Glory sessions gets its own time to shine.",
                    "short": "A rarity from the Glory sessions gets its own time to shine."
                },
                "isComplete": true
            },
            "relationships": {
                "tracks": {
                    "href": "/v1/catalog/gb/albums/1541357258/tracks",
                    "data": [
                        {
                            "id": "1541357261",
                            "type": "songs",
                            "href": "/v1/catalog/gb/songs/1541357261",
                            "attributes": {
                                "albumName": "Swimming In The Stars - Single",
                                "genreNames": [
                                    "Pop",
                                    "Music"
                                ],
                                "trackNumber": 1,
                                "durationInMillis": 201342,
                                "releaseDate": "2020-12-04",
                                "isrc": "USRC12003080",
                                "artwork": {
                                    "width": 3000,
                                    "height": 3000,
                                    "url": "https://is1-ssl.mzstatic.com/image/thumb/Music114/v4/01/e3/ee/01e3ee21-e857-739d-7673-7235bb87961b/886448814054.jpg/{w}x{h}bb.jpg",
                                    "bgColor": "11141e",
                                    "textColor1": "c9cbd2",
                                    "textColor2": "b2bacc",
                                    "textColor3": "a4a6ad",
                                    "textColor4": "9299a9"
                                },
                                "composerName": "Matthew Koma, Dan Book & Alexei Misoul",
                                "playParams": {
                                    "id": "1541357261",
                                    "kind": "song"
                                },
                                "url": "https://music.apple.com/gb/album/swimming-in-the-stars/1541357258?i=1541357261",
                                "discNumber": 1,
                                "hasLyrics": true,
                                "isAppleDigitalMaster": false,
                                "name": "Swimming In The Stars",
                                "previews": [
                                    {
                                        "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/51/50/25/515025fe-fa76-c27d-0dd3-6c22fd8c178b/mzaf_17739303067807440793.plus.aac.p.m4a"
                                    }
                                ],
                                "artistName": "Britney Spears"
                            }
                        }
                    ]
                },
                "artists": {
                    "href": "/v1/catalog/gb/albums/1541357258/artists",
                    "data": [
                        {
                            "id": "217005",
                            "type": "artists",
                            "href": "/v1/catalog/gb/artists/217005"
                        }
                    ]
                }
            }
        }
    ]
}
"""
