//
//  SuggestionsJSON.swift
//  PumpyAnalyticsTests
//
//  Created by Jack Vanderpump on 03/09/2022.
//

import Foundation

class SuggestionsHelper {
    
    static let response = """
{
    "data": [
        {
            "id": "6-27s5hU6azhJY",
            "type": "personal-recommendation",
            "href": "/v1/me/recommendations/6-27s5hU6azhJY",
            "attributes": {
                "isGroupRecommendation": false,
                "nextUpdateDate": "2022-09-02T10:59:59Z",
                "resourceTypes": [
                    "playlists"
                ],
                "title": {
                    "stringForDisplay": "Made for You"
                },
                "kind": "music-recommendations"
            },
            "relationships": {
                "contents": {
                    "href": "/v1/me/recommendations/6-27s5hU6azhJY/contents",
                    "data": [
                        {
                            "id": "pl.pm-d5779e520ff52d7f21c3c3e53f8eb936",
                            "type": "playlists",
                            "href": "/v1/catalog/gb/playlists/pl.pm-d5779e520ff52d7f21c3c3e53f8eb936",
                            "attributes": {
                                "curatorName": "Apple Music for Pumpy Music",
                                "lastModifiedDate": "2022-09-02T10:52:01Z",
                                "isChart": false,
                                "name": "New Music Mix",
                                "playlistType": "personal-mix",
                                "description": {
                                    "standard": "Discover new music from artists we think you'll like. Refreshed every Friday."
                                },
                                "artwork": {
                                    "width": 4320,
                                    "height": 1080,
                                    "url": "https://is2-ssl.mzstatic.com/image/thumb/Features114/v4/e6/36/94/e636949e-4f6e-4cad-8b2c-bcba7b2e36d0/U0MtTVMtV1ctUGVyc29uYWxpemVkX01peGVzLU5ld011c2ljLUFEQU1fSUQ9MTExOTM4OTk2Ny5wbmc.png/{w}x{h}cc.jpg",
                                    "bgColor": "fc6a7b",
                                    "textColor1": "ffffff",
                                    "textColor2": "121010",
                                    "textColor3": "351418",
                                    "textColor4": "351f21"
                                },
                                "playParams": {
                                    "id": "pl.pm-d5779e520ff52d7f21c3c3e53f8eb936",
                                    "kind": "playlist",
                                    "versionHash": "3be43beb7b3d8c55969cc64f4b7c9ed0bb91ec6e5e387f032fddd9513ed44f41"
                                },
                                "url": "https://music.apple.com/gb/playlist/new-music-mix/pl.pm-d5779e520ff52d7f21c3c3e53f8eb936"
                            }
                        }
                    ]
                }
            }
        }
    ]
}
"""
}
