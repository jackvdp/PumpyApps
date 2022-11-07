//
//  MockSearchGateway.swift
//  PumpyAnalyticsTests
//
//  Created by Jack Vanderpump on 16/09/2022.
//

import Foundation
@testable import PumpyAnalytics

class MockSearchTracksGateway: SearchTracksGatewayProtocol {
    func run(_ term: String, authManager: AuthorisationManager, completion: @escaping (SongSearchResults?, Int) -> ()) {
        let model = searchJSON.convertJSONStringToModel(to: SongSearchResults.self)
        completion(model, 200)
    }
}

private let searchJSON =
"""
{
    "results": {
        "songs": {
            "href": "/v1/catalog/gb/search?limit=25&term=ed+sheeran&types=songs",
            "next": "/v1/catalog/gb/search?offset=25&term=ed+sheeran&types=songs",
            "data": [
                {
                    "id": "1624518834",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1624518834",
                    "attributes": {
                        "albumName": "Close To Home",
                        "genreNames": [
                            "Hip-Hop/Rap",
                            "Music"
                        ],
                        "trackNumber": 14,
                        "durationInMillis": 198057,
                        "releaseDate": "2022-08-19",
                        "isrc": "GBUM72202832",
                        "artwork": {
                            "width": 3000,
                            "height": 3000,
                            "url": "https://is4-ssl.mzstatic.com/image/thumb/Music122/v4/50/37/cd/5037cd6f-0b04-64be-c1d0-c2cb33ac3772/22UMGIM45027.rgb.jpg/{w}x{h}bb.jpg",
                            "bgColor": "474747",
                            "textColor1": "f5f5f5",
                            "textColor2": "ededed",
                            "textColor3": "d2d2d2",
                            "textColor4": "cccccc"
                        },
                        "composerName": "Aitch, Ed Sheeran, Fraser T. Smith, Whyjay & LiTek",
                        "url": "https://music.apple.com/gb/album/my-g/1624517579?i=1624518834",
                        "playParams": {
                            "id": "1624518834",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": true,
                        "name": "My G",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/89/aa/99/89aa996c-2935-d8b2-3007-f6d44b4fca1c/mzaf_660855590793245795.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Aitch & Ed Sheeran",
                        "contentRating": "explicit"
                    }
                },
                {
                    "id": "1645124141",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1645124141",
                    "attributes": {
                        "albumName": "Self Care: Latinx Wellness",
                        "genreNames": [
                            "Latin Urban",
                            "Music",
                            "Latin"
                        ],
                        "trackNumber": 11,
                        "releaseDate": "2022-09-15",
                        "durationInMillis": 190893,
                        "isrc": "QZM5U2200344",
                        "artwork": {
                            "width": 3000,
                            "height": 3000,
                            "url": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/43/a4/a2/43a4a2ce-acc4-17c7-7baf-a9a815f8128c/22UM1IM04938.rgb.jpg/{w}x{h}bb.jpg",
                            "bgColor": "3553ad",
                            "textColor1": "fcf0e0",
                            "textColor2": "ffcd00",
                            "textColor3": "d4d1d6",
                            "textColor4": "d6b422"
                        },
                        "composerName": "J Balvin, Ed Sheeran, Michael Brun, Justin Quiles & Keityn",
                        "url": "https://music.apple.com/gb/album/forever-my-love/1645123265?i=1645124141",
                        "playParams": {
                            "id": "1645124141",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": false,
                        "hasLyrics": false,
                        "name": "Forever My Love",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/36/95/e3/3695e32f-a62e-8ed0-0c01-fade68c9fe57/mzaf_389923844552193488.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "J Balvin & Ed Sheeran"
                    }
                },
                {
                    "id": "1571330212",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1571330212",
                    "attributes": {
                        "albumName": "Bad Habits - Single",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 1,
                        "durationInMillis": 230747,
                        "releaseDate": "2020-09-03",
                        "isrc": "GBAHS2100318",
                        "artwork": {
                            "width": 4000,
                            "height": 4000,
                            "url": "https://is2-ssl.mzstatic.com/image/thumb/Music115/v4/63/45/cc/6345cc98-aa83-ad6e-e3c9-1a36ff9838a4/190296614316.jpg/{w}x{h}bb.jpg",
                            "bgColor": "bf0f00",
                            "textColor1": "fdcbde",
                            "textColor2": "fdc3b6",
                            "textColor3": "f1a5b2",
                            "textColor4": "f09f91"
                        },
                        "composerName": "Ed Sheeran, Fred Gibson & Johnny McDaid",
                        "url": "https://music.apple.com/gb/album/bad-habits/1571330207?i=1571330212",
                        "playParams": {
                            "id": "1571330212",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": true,
                        "name": "Bad Habits",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/85/39/87/853987ac-e434-51fe-1413-2cf172e851dd/mzaf_7373563199881129757.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1600505537",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1600505537",
                    "attributes": {
                        "albumName": "Peru - Single",
                        "genreNames": [
                            "Afrobeats",
                            "Music",
                            "African"
                        ],
                        "trackNumber": 1,
                        "durationInMillis": 188111,
                        "releaseDate": "2021-12-24",
                        "isrc": "USUYG1403104",
                        "artwork": {
                            "width": 3000,
                            "height": 3000,
                            "url": "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/63/dd/16/63dd1612-9a02-11da-1923-3b4dbcb56140/21UM1IM56071.rgb.jpg/{w}x{h}bb.jpg",
                            "bgColor": "b4261d",
                            "textColor1": "faebe2",
                            "textColor2": "f8aa99",
                            "textColor3": "ecc4bb",
                            "textColor4": "ea8f80"
                        },
                        "composerName": "Fireboy DML, Ed Sheeran, Ivory Scott, AOD & Kolten",
                        "url": "https://music.apple.com/gb/album/peru/1600505534?i=1600505537",
                        "playParams": {
                            "id": "1600505537",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": true,
                        "name": "Peru",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/67/7e/38/677e38dc-33fd-0af9-9dea-6eb95694929d/mzaf_2096281351763310383.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Fireboy DML & Ed Sheeran"
                    }
                },
                {
                    "id": "1193683175",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1193683175",
                    "attributes": {
                        "albumName": "÷ (Deluxe)",
                        "genreNames": [
                            "Pop",
                            "Music",
                            "Singer/Songwriter"
                        ],
                        "trackNumber": 5,
                        "releaseDate": "2017-03-03",
                        "durationInMillis": 263400,
                        "isrc": "GBAHS1700007",
                        "artwork": {
                            "width": 3000,
                            "height": 3000,
                            "url": "https://is2-ssl.mzstatic.com/image/thumb/Music122/v4/18/3c/81/183c8163-7541-7043-2f0c-e55c23b265f5/190295851286.jpg/{w}x{h}bb.jpg",
                            "bgColor": "151716",
                            "textColor1": "7ddafa",
                            "textColor2": "69d5f1",
                            "textColor3": "68b3cc",
                            "textColor4": "58afc5"
                        },
                        "composerName": "Ed Sheeran",
                        "url": "https://music.apple.com/gb/album/perfect/1193682944?i=1193683175",
                        "playParams": {
                            "id": "1193683175",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": true,
                        "hasLyrics": true,
                        "name": "Perfect",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/9d/d1/8e/9dd18e4e-ef3c-06aa-ed76-5526fe3aea5b/mzaf_2298216636700982282.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1581087034",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1581087034",
                    "attributes": {
                        "albumName": "=",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 2,
                        "durationInMillis": 207853,
                        "releaseDate": "2021-09-09",
                        "isrc": "GBAHS2100671",
                        "artwork": {
                            "width": 4000,
                            "height": 4000,
                            "url": "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/c5/d8/c6/c5d8c675-63e3-6632-33db-2401eabe574d/190296491412.jpg/{w}x{h}bb.jpg",
                            "bgColor": "350200",
                            "textColor1": "fed400",
                            "textColor2": "f54f35",
                            "textColor3": "d5aa00",
                            "textColor4": "cf402a"
                        },
                        "composerName": "Ed Sheeran, Johnny McDaid, Kal Lavelle & Steve Mac",
                        "url": "https://music.apple.com/gb/album/shivers/1581087024?i=1581087034",
                        "playParams": {
                            "id": "1581087034",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": true,
                        "name": "Shivers",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/b7/5d/69/b75d69a5-ab31-ca1a-62aa-3985abaaa59c/mzaf_16578619813671696376.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1622847474",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1622847474",
                    "attributes": {
                        "albumName": "Summer Party 2022",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 19,
                        "releaseDate": "2020-09-03",
                        "durationInMillis": 230747,
                        "isrc": "GBAHS2100318",
                        "artwork": {
                            "width": 1400,
                            "height": 1400,
                            "url": "https://is3-ssl.mzstatic.com/image/thumb/Music122/v4/2e/76/d0/2e76d054-62d7-ed1a-b726-808be158f974/5059460136083.jpg/{w}x{h}bb.jpg",
                            "bgColor": "aaa4fc",
                            "textColor1": "100908",
                            "textColor2": "1b1412",
                            "textColor3": "2e2838",
                            "textColor4": "373141"
                        },
                        "url": "https://music.apple.com/gb/album/bad-habits/1622845795?i=1622847474",
                        "playParams": {
                            "id": "1622847474",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": false,
                        "hasLyrics": true,
                        "name": "Bad Habits",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/39/fc/68/39fc682f-792a-f06e-9da4-85c0fcfb660b/mzaf_12793255134289914828.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1634416438",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1634416438",
                    "attributes": {
                        "albumName": "Veepie Vroom – Hits Van Nu",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 9,
                        "durationInMillis": 236907,
                        "releaseDate": "2021-10-29",
                        "isrc": "GBAHS2100673",
                        "artwork": {
                            "width": 1400,
                            "height": 1400,
                            "url": "https://is2-ssl.mzstatic.com/image/thumb/Music112/v4/2f/f2/56/2ff256b4-d803-7fd6-4003-2b15d8e719ff/5059460146518.jpg/{w}x{h}bb.jpg",
                            "bgColor": "011401",
                            "textColor1": "daff00",
                            "textColor2": "53d20a",
                            "textColor3": "aecf00",
                            "textColor4": "43ac08"
                        },
                        "url": "https://music.apple.com/gb/album/overpass-graffiti/1634415818?i=1634416438",
                        "playParams": {
                            "id": "1634416438",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": false,
                        "name": "Overpass Graffiti",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/3d/4b/50/3d4b505a-269a-cda9-d7ad-7d69eca5054d/mzaf_12264895850473673526.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1622846128",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1622846128",
                    "attributes": {
                        "albumName": "Summer Party 2022",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 3,
                        "durationInMillis": 207853,
                        "releaseDate": "2021-09-09",
                        "isrc": "GBAHS2100671",
                        "artwork": {
                            "width": 1400,
                            "height": 1400,
                            "url": "https://is3-ssl.mzstatic.com/image/thumb/Music122/v4/2e/76/d0/2e76d054-62d7-ed1a-b726-808be158f974/5059460136083.jpg/{w}x{h}bb.jpg",
                            "bgColor": "aaa4fc",
                            "textColor1": "100908",
                            "textColor2": "1b1412",
                            "textColor3": "2e2838",
                            "textColor4": "373141"
                        },
                        "playParams": {
                            "id": "1622846128",
                            "kind": "song"
                        },
                        "url": "https://music.apple.com/gb/album/shivers/1622845795?i=1622846128",
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": false,
                        "name": "Shivers",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/7d/60/69/7d60692d-7ddf-2ff0-0e57-6948e6217486/mzaf_4315541608290049815.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1630144762",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1630144762",
                    "attributes": {
                        "albumName": "20er Hits",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 1,
                        "durationInMillis": 230747,
                        "releaseDate": "2022-07-08",
                        "isrc": "GBAHS2100318",
                        "artwork": {
                            "width": 1400,
                            "height": 1400,
                            "url": "https://is1-ssl.mzstatic.com/image/thumb/Music112/v4/28/bc/22/28bc224a-e2b1-4b81-a2c0-cd85bc041965/5059460138667.jpg/{w}x{h}bb.jpg",
                            "bgColor": "f2efea",
                            "textColor1": "000000",
                            "textColor2": "57093d",
                            "textColor3": "302f2e",
                            "textColor4": "76375f"
                        },
                        "playParams": {
                            "id": "1630144762",
                            "kind": "song"
                        },
                        "url": "https://music.apple.com/gb/album/bad-habits/1630144758?i=1630144762",
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": false,
                        "name": "Bad Habits",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/1a/a0/05/1aa00534-bee4-f4b8-c1e5-465bde31ffc6/mzaf_2307545657982923395.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1629606114",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1629606114",
                    "attributes": {
                        "albumName": "PANORAMA - Viral Hits",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 5,
                        "releaseDate": "2022-04-22",
                        "durationInMillis": 163450,
                        "isrc": "GBAHS2200506",
                        "artwork": {
                            "width": 1400,
                            "height": 1400,
                            "url": "https://is1-ssl.mzstatic.com/image/thumb/Music122/v4/57/55/fd/5755fd93-d8b3-2a05-7d89-a57bed74b453/5059460140110.jpg/{w}x{h}bb.jpg",
                            "bgColor": "0b0704",
                            "textColor1": "f7fcf6",
                            "textColor2": "02b5ea",
                            "textColor3": "c7cbc5",
                            "textColor4": "0392bc"
                        },
                        "url": "https://music.apple.com/gb/album/2step-feat-lil-baby/1629605611?i=1629606114",
                        "playParams": {
                            "id": "1629606114",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": false,
                        "hasLyrics": true,
                        "name": "2step (feat. Lil Baby)",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/a9/48/e8/a948e893-30e0-1bbd-e451-ab4c14ecd838/mzaf_12732992108784948342.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1193683176",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1193683176",
                    "attributes": {
                        "albumName": "÷ (Deluxe)",
                        "genreNames": [
                            "Pop",
                            "Music",
                            "Singer/Songwriter"
                        ],
                        "trackNumber": 6,
                        "releaseDate": "2017-03-03",
                        "durationInMillis": 170827,
                        "isrc": "GBAHS1700008",
                        "artwork": {
                            "width": 3000,
                            "height": 3000,
                            "url": "https://is2-ssl.mzstatic.com/image/thumb/Music122/v4/18/3c/81/183c8163-7541-7043-2f0c-e55c23b265f5/190295851286.jpg/{w}x{h}bb.jpg",
                            "bgColor": "151716",
                            "textColor1": "7ddafa",
                            "textColor2": "69d5f1",
                            "textColor3": "68b3cc",
                            "textColor4": "58afc5"
                        },
                        "composerName": "Amy Wadge, Damian McKee, Eamon Murray, Ed Sheeran, Foy Vance, Johnny McDaid, Liam Bradley, Niamh Dunne & Sean Graham",
                        "url": "https://music.apple.com/gb/album/galway-girl/1193682944?i=1193683176",
                        "playParams": {
                            "id": "1193683176",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": true,
                        "hasLyrics": true,
                        "name": "Galway Girl",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/b0/62/76/b0627679-54d6-e54b-58e8-901aeae3b1a4/mzaf_18416652789519821646.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1193683109",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1193683109",
                    "attributes": {
                        "albumName": "÷ (Deluxe)",
                        "genreNames": [
                            "Pop",
                            "Music",
                            "Singer/Songwriter"
                        ],
                        "trackNumber": 2,
                        "durationInMillis": 261154,
                        "releaseDate": "2017-01-06",
                        "isrc": "GBAHS1700004",
                        "artwork": {
                            "width": 3000,
                            "height": 3000,
                            "url": "https://is2-ssl.mzstatic.com/image/thumb/Music122/v4/18/3c/81/183c8163-7541-7043-2f0c-e55c23b265f5/190295851286.jpg/{w}x{h}bb.jpg",
                            "bgColor": "151716",
                            "textColor1": "7ddafa",
                            "textColor2": "69d5f1",
                            "textColor3": "68b3cc",
                            "textColor4": "58afc5"
                        },
                        "composerName": "Benjamin Levin & Ed Sheeran",
                        "playParams": {
                            "id": "1193683109",
                            "kind": "song"
                        },
                        "url": "https://music.apple.com/gb/album/castle-on-the-hill/1193682944?i=1193683109",
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": true,
                        "name": "Castle on the Hill",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/b3/f8/5b/b3f85b4e-a854-86ff-e4dc-36b9f4521647/mzaf_1061911778521824564.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "858517867",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/858517867",
                    "attributes": {
                        "albumName": "x (Deluxe Edition)",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 6,
                        "durationInMillis": 258987,
                        "releaseDate": "2014-06-20",
                        "isrc": "GBAHS1400094",
                        "artwork": {
                            "width": 1425,
                            "height": 1425,
                            "url": "https://is3-ssl.mzstatic.com/image/thumb/Features124/v4/99/ac/50/99ac5005-1706-b3ce-95f0-b58f2f373dc5/dj.sagclawj.jpg/{w}x{h}bb.jpg",
                            "bgColor": "000104",
                            "textColor1": "25e667",
                            "textColor2": "1cdd5e",
                            "textColor3": "1eb853",
                            "textColor4": "16b14c"
                        },
                        "composerName": "Ed Sheeran, Johnny McDaid, Martin Harrington & Thomas, Leonard",
                        "url": "https://music.apple.com/gb/album/photograph/858517827?i=858517867",
                        "playParams": {
                            "id": "858517867",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": false,
                        "name": "Photograph",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/b3/fe/3c/b3fe3c77-3bec-5597-976d-0bcc67ca13a0/mzaf_16132472904084123513.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1193683174",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1193683174",
                    "attributes": {
                        "albumName": "÷ (Deluxe)",
                        "genreNames": [
                            "Pop",
                            "Music",
                            "Singer/Songwriter"
                        ],
                        "trackNumber": 4,
                        "releaseDate": "2017-01-06",
                        "durationInMillis": 233713,
                        "isrc": "GBAHS1700003",
                        "artwork": {
                            "width": 3000,
                            "height": 3000,
                            "url": "https://is2-ssl.mzstatic.com/image/thumb/Music122/v4/18/3c/81/183c8163-7541-7043-2f0c-e55c23b265f5/190295851286.jpg/{w}x{h}bb.jpg",
                            "bgColor": "151716",
                            "textColor1": "7ddafa",
                            "textColor2": "69d5f1",
                            "textColor3": "68b3cc",
                            "textColor4": "58afc5"
                        },
                        "composerName": "Ed Sheeran, Johnny McDaid, Kandi Burruss, Kevin Briggs, Steve Mac & Tameka Cottle",
                        "url": "https://music.apple.com/gb/album/shape-of-you/1193682944?i=1193683174",
                        "playParams": {
                            "id": "1193683174",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": true,
                        "hasLyrics": true,
                        "name": "Shape of You",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/a7/a1/7c/a7a17c8f-c5e4-9b44-3b4c-36f11e83857e/mzaf_10311791008996058291.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "858517873",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/858517873",
                    "attributes": {
                        "albumName": "x (Deluxe Edition)",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 11,
                        "releaseDate": "2014-06-20",
                        "durationInMillis": 281560,
                        "isrc": "GBAHS1400099",
                        "artwork": {
                            "width": 1425,
                            "height": 1425,
                            "url": "https://is3-ssl.mzstatic.com/image/thumb/Features124/v4/99/ac/50/99ac5005-1706-b3ce-95f0-b58f2f373dc5/dj.sagclawj.jpg/{w}x{h}bb.jpg",
                            "bgColor": "000104",
                            "textColor1": "25e667",
                            "textColor2": "1cdd5e",
                            "textColor3": "1eb853",
                            "textColor4": "16b14c"
                        },
                        "composerName": "Amy Wadge & Ed Sheeran",
                        "url": "https://music.apple.com/gb/album/thinking-out-loud/858517827?i=858517873",
                        "playParams": {
                            "id": "858517873",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": false,
                        "hasLyrics": true,
                        "name": "Thinking Out Loud",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/f7/af/80/f7af8039-b86e-f77c-501f-51e29ca114eb/mzaf_8382985039242708108.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1193683193",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1193683193",
                    "attributes": {
                        "albumName": "÷ (Deluxe)",
                        "genreNames": [
                            "Pop",
                            "Music",
                            "Singer/Songwriter"
                        ],
                        "trackNumber": 12,
                        "releaseDate": "2017-03-03",
                        "durationInMillis": 221107,
                        "isrc": "GBAHS1700014",
                        "artwork": {
                            "width": 3000,
                            "height": 3000,
                            "url": "https://is2-ssl.mzstatic.com/image/thumb/Music122/v4/18/3c/81/183c8163-7541-7043-2f0c-e55c23b265f5/190295851286.jpg/{w}x{h}bb.jpg",
                            "bgColor": "151716",
                            "textColor1": "7ddafa",
                            "textColor2": "69d5f1",
                            "textColor3": "68b3cc",
                            "textColor4": "58afc5"
                        },
                        "composerName": "Benjamin Levin, Ed Sheeran & Johnny McDaid",
                        "url": "https://music.apple.com/gb/album/supermarket-flowers/1193682944?i=1193683193",
                        "playParams": {
                            "id": "1193683193",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": true,
                        "hasLyrics": true,
                        "name": "Supermarket Flowers",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/6e/ef/98/6eef9877-c045-228f-9dbe-35f53c80aafa/mzaf_4092802487055678645.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1581087534",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1581087534",
                    "attributes": {
                        "albumName": "=",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 5,
                        "durationInMillis": 236907,
                        "releaseDate": "2021-10-29",
                        "isrc": "GBAHS2100673",
                        "artwork": {
                            "width": 4000,
                            "height": 4000,
                            "url": "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/c5/d8/c6/c5d8c675-63e3-6632-33db-2401eabe574d/190296491412.jpg/{w}x{h}bb.jpg",
                            "bgColor": "350200",
                            "textColor1": "fed400",
                            "textColor2": "f54f35",
                            "textColor3": "d5aa00",
                            "textColor4": "cf402a"
                        },
                        "composerName": "Ed Sheeran, Fred Gibson & Johnny McDaid",
                        "playParams": {
                            "id": "1581087534",
                            "kind": "song"
                        },
                        "url": "https://music.apple.com/gb/album/overpass-graffiti/1581087024?i=1581087534",
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": true,
                        "name": "Overpass Graffiti",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/f0/5b/e2/f05be265-99c7-2c39-918a-9d0df5f21c08/mzaf_8907544265885682270.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1618442302",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1618442302",
                    "attributes": {
                        "albumName": "2step (feat. Lil Baby) - Single",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 1,
                        "durationInMillis": 163450,
                        "releaseDate": "2022-04-22",
                        "isrc": "GBAHS2200506",
                        "artwork": {
                            "width": 4000,
                            "height": 4000,
                            "url": "https://is5-ssl.mzstatic.com/image/thumb/Music122/v4/6e/2f/9b/6e2f9b58-78b1-4c1f-dce7-faee3c15678d/5054197150975.jpg/{w}x{h}bb.jpg",
                            "bgColor": "c00c00",
                            "textColor1": "fff8f6",
                            "textColor2": "fbe7c3",
                            "textColor3": "f2c8c4",
                            "textColor4": "efbb9c"
                        },
                        "composerName": "Andrew Wotman, David Hodges, Ed Sheeran, Lil Baby & Louis Bell",
                        "playParams": {
                            "id": "1618442302",
                            "kind": "song"
                        },
                        "url": "https://music.apple.com/gb/album/2step-feat-lil-baby/1618441859?i=1618442302",
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": true,
                        "name": "2step (feat. Lil Baby)",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/ab/00/e7/ab00e73d-b744-5d1d-6928-cab3d13770ff/mzaf_495008882223457362.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "965346222",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/965346222",
                    "attributes": {
                        "albumName": "Bloodstream - Single",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 1,
                        "durationInMillis": 308877,
                        "releaseDate": "2015-02-11",
                        "isrc": "GBAHS1500062",
                        "artwork": {
                            "width": 2400,
                            "height": 2400,
                            "url": "https://is4-ssl.mzstatic.com/image/thumb/Music1/v4/82/d4/96/82d49638-8292-e322-952a-6614b3f5557f/825646135776.jpg/{w}x{h}bb.jpg",
                            "bgColor": "001e06",
                            "textColor1": "1eeb63",
                            "textColor2": "30e264",
                            "textColor3": "18c250",
                            "textColor4": "26bb51"
                        },
                        "composerName": "Ed Sheeran, Gary Lightbody, Johnny McDaid & Rudimental",
                        "playParams": {
                            "id": "965346222",
                            "kind": "song"
                        },
                        "url": "https://music.apple.com/gb/album/bloodstream/965346220?i=965346222",
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": false,
                        "name": "Bloodstream",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/f5/2b/0a/f52b0a1d-3a95-64bd-215a-0847a15dd731/mzaf_12883502707229457810.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran & Rudimental"
                    }
                },
                {
                    "id": "448213995",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/448213995",
                    "attributes": {
                        "albumName": "+ (Deluxe Version)",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 1,
                        "releaseDate": "2010-02-07",
                        "durationInMillis": 258373,
                        "isrc": "GBAHS1100095",
                        "artwork": {
                            "width": 1425,
                            "height": 1425,
                            "url": "https://is5-ssl.mzstatic.com/image/thumb/Features115/v4/65/fb/84/65fb8432-f539-d67d-0670-b1358d16e5af/contsched.zkbwdtfj.jpg/{w}x{h}bb.jpg",
                            "bgColor": "9c440f",
                            "textColor1": "fef1eb",
                            "textColor2": "f5c591",
                            "textColor3": "eacebf",
                            "textColor4": "e3ab77"
                        },
                        "composerName": "Ed Sheeran",
                        "url": "https://music.apple.com/gb/album/the-a-team/448213992?i=448213995",
                        "playParams": {
                            "id": "448213995",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": false,
                        "hasLyrics": true,
                        "name": "The A Team",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/67/65/39/676539a0-b904-2da4-56a1-12f017592cdb/mzaf_2009054974100173925.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1318665245",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1318665245",
                    "attributes": {
                        "albumName": "Perfect Duet (with Beyoncé) - Single",
                        "genreNames": [
                            "Pop",
                            "Music",
                            "Singer/Songwriter"
                        ],
                        "trackNumber": 1,
                        "releaseDate": "2017-11-30",
                        "durationInMillis": 259550,
                        "isrc": "GBAHS1701211",
                        "artwork": {
                            "width": 1500,
                            "height": 1500,
                            "url": "https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/6f/24/35/6f2435c0-bd47-5882-8211-c4bab6661841/190295694975.jpg/{w}x{h}bb.jpg",
                            "bgColor": "000000",
                            "textColor1": "ffffff",
                            "textColor2": "43caf8",
                            "textColor3": "cbcbcb",
                            "textColor4": "35a2c6"
                        },
                        "composerName": "Beyoncé, Beyoncé Knowles & Ed Sheeran",
                        "url": "https://music.apple.com/gb/album/perfect-duet-with-beyonc%C3%A9/1318665235?i=1318665245",
                        "playParams": {
                            "id": "1318665245",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": false,
                        "hasLyrics": true,
                        "name": "Perfect Duet (with Beyoncé)",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/14/ec/98/14ec98b7-e0e2-ae04-9fd3-04b40e028429/mzaf_9974831369507298682.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1464545850",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1464545850",
                    "attributes": {
                        "albumName": "No.6 Collaborations Project",
                        "genreNames": [
                            "Pop",
                            "Music"
                        ],
                        "trackNumber": 4,
                        "durationInMillis": 189733,
                        "releaseDate": "2019-07-12",
                        "isrc": "GBAHS1900716",
                        "artwork": {
                            "width": 4000,
                            "height": 4000,
                            "url": "https://is4-ssl.mzstatic.com/image/thumb/Music114/v4/cb/13/65/cb136538-bf34-0224-deed-1993681961b4/190295412791.jpg/{w}x{h}bb.jpg",
                            "bgColor": "fafafa",
                            "textColor1": "000000",
                            "textColor2": "232323",
                            "textColor3": "323232",
                            "textColor4": "4e4e4e"
                        },
                        "composerName": "Ed Sheeran, Fred Gibson, Max Martin, Michael Omari & Shellback",
                        "playParams": {
                            "id": "1464545850",
                            "kind": "song"
                        },
                        "url": "https://music.apple.com/gb/album/take-me-back-to-london-feat-stormzy/1464545600?i=1464545850",
                        "discNumber": 1,
                        "hasLyrics": true,
                        "isAppleDigitalMaster": true,
                        "name": "Take Me Back to London (feat. Stormzy)",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/77/de/f9/77def914-5bb7-ae24-edbd-eb18b7f13205/mzaf_15146054196922714058.plus.aac.p.m4a"
                            }
                        ],
                        "contentRating": "explicit",
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1440863437",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1440863437",
                    "attributes": {
                        "albumName": "The Hobbit - The Desolation of Smaug (Original Motion Picture Soundtrack) [Special Edition]",
                        "genreNames": [
                            "Soundtrack",
                            "Music"
                        ],
                        "trackNumber": 28,
                        "releaseDate": "2013-11-05",
                        "durationInMillis": 300840,
                        "isrc": "USNLR1300728",
                        "artwork": {
                            "width": 1500,
                            "height": 1500,
                            "url": "https://is4-ssl.mzstatic.com/image/thumb/Music128/v4/97/cd/7c/97cd7cdd-eac8-7a61-83de-a950a15de582/00602537635610.rgb.jpg/{w}x{h}bb.jpg",
                            "bgColor": "130417",
                            "textColor1": "ebbf55",
                            "textColor2": "d59750",
                            "textColor3": "c09949",
                            "textColor4": "ae7944"
                        },
                        "composerName": "Ed Sheeran",
                        "url": "https://music.apple.com/gb/album/i-see-fire/1440861845?i=1440863437",
                        "playParams": {
                            "id": "1440863437",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": true,
                        "hasLyrics": true,
                        "name": "I See Fire",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/41/24/7a/41247a22-78c7-bd03-31cf-28db6652c209/mzaf_659993634139416977.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                },
                {
                    "id": "1193683173",
                    "type": "songs",
                    "href": "/v1/catalog/gb/songs/1193683173",
                    "attributes": {
                        "albumName": "÷ (Deluxe)",
                        "genreNames": [
                            "Pop",
                            "Music",
                            "Singer/Songwriter"
                        ],
                        "trackNumber": 3,
                        "releaseDate": "2017-03-03",
                        "durationInMillis": 238440,
                        "isrc": "GBAHS1700006",
                        "artwork": {
                            "width": 3000,
                            "height": 3000,
                            "url": "https://is2-ssl.mzstatic.com/image/thumb/Music122/v4/18/3c/81/183c8163-7541-7043-2f0c-e55c23b265f5/190295851286.jpg/{w}x{h}bb.jpg",
                            "bgColor": "151716",
                            "textColor1": "7ddafa",
                            "textColor2": "69d5f1",
                            "textColor3": "68b3cc",
                            "textColor4": "58afc5"
                        },
                        "composerName": "Benjamin Levin, Ed Sheeran & Julia Michaels",
                        "url": "https://music.apple.com/gb/album/dive/1193682944?i=1193683173",
                        "playParams": {
                            "id": "1193683173",
                            "kind": "song"
                        },
                        "discNumber": 1,
                        "isAppleDigitalMaster": true,
                        "hasLyrics": true,
                        "name": "Dive",
                        "previews": [
                            {
                                "url": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/70/e1/fd/70e1fd57-cebd-e808-5a4a-944a70212a39/mzaf_5027892045020862303.plus.aac.p.m4a"
                            }
                        ],
                        "artistName": "Ed Sheeran"
                    }
                }
            ]
        }
    },
    "meta": {
        "results": {
            "order": [
                "songs"
            ],
            "rawOrder": [
                "songs"
            ]
        }
    }
}
"""
