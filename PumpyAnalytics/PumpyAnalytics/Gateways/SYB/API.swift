// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum SearchType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case album
  case artist
  case category
  @available(*, deprecated, message: "Use playlist instead")
  case soundtrack
  case playlist
  case track
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "album": self = .album
      case "artist": self = .artist
      case "category": self = .category
      case "soundtrack": self = .soundtrack
      case "playlist": self = .playlist
      case "track": self = .track
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .album: return "album"
      case .artist: return "artist"
      case .category: return "category"
      case .soundtrack: return "soundtrack"
      case .playlist: return "playlist"
      case .track: return "track"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: SearchType, rhs: SearchType) -> Bool {
    switch (lhs, rhs) {
      case (.album, .album): return true
      case (.artist, .artist): return true
      case (.category, .category): return true
      case (.soundtrack, .soundtrack): return true
      case (.playlist, .playlist): return true
      case (.track, .track): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [SearchType] {
    return [
      .album,
      .artist,
      .category,
      .soundtrack,
      .playlist,
      .track,
    ]
  }
}

public final class LoginMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation Login($email: String!, $password: String!) {
      loginUser(input: {email: $email, password: $password}) {
        __typename
        token
        refreshToken
      }
    }
    """

  public let operationName: String = "Login"

  public var email: String
  public var password: String

  public init(email: String, password: String) {
    self.email = email
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["email": email, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("loginUser", arguments: ["input": ["email": GraphQLVariable("email"), "password": GraphQLVariable("password")]], type: .object(LoginUser.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(loginUser: LoginUser? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "loginUser": loginUser.flatMap { (value: LoginUser) -> ResultMap in value.resultMap }])
    }

    public var loginUser: LoginUser? {
      get {
        return (resultMap["loginUser"] as? ResultMap).flatMap { LoginUser(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "loginUser")
      }
    }

    public struct LoginUser: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["LoginUserPayload"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("token", type: .nonNull(.scalar(String.self))),
          GraphQLField("refreshToken", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String, refreshToken: String) {
        self.init(unsafeResultMap: ["__typename": "LoginUserPayload", "token": token, "refreshToken": refreshToken])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }

      public var refreshToken: String {
        get {
          return resultMap["refreshToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "refreshToken")
        }
      }
    }
  }
}

public final class GetPlaylistQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetPlaylist($playlistID: ID!) {
      playlist(id: $playlistID) {
        __typename
        name
        curator {
          __typename
          name
        }
        display {
          __typename
          image {
            __typename
            placeholder
          }
        }
        description
        shortDescription
        genres(first: 1000) {
          __typename
          edges {
            __typename
            node {
              __typename
              name
            }
          }
        }
        tracks(first: 1000, market: GB) {
          __typename
          edges {
            __typename
            node {
              __typename
              title
              artists {
                __typename
                name
              }
              album {
                __typename
                title
              }
              explicit
              id
              isrc
              previewUrl
              recognizability
              display {
                __typename
                image {
                  __typename
                  placeholder
                }
              }
              shareUrl
            }
          }
        }
      }
    }
    """

  public let operationName: String = "GetPlaylist"

  public var playlistID: GraphQLID

  public init(playlistID: GraphQLID) {
    self.playlistID = playlistID
  }

  public var variables: GraphQLMap? {
    return ["playlistID": playlistID]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("playlist", arguments: ["id": GraphQLVariable("playlistID")], type: .object(Playlist.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(playlist: Playlist? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "playlist": playlist.flatMap { (value: Playlist) -> ResultMap in value.resultMap }])
    }

    public var playlist: Playlist? {
      get {
        return (resultMap["playlist"] as? ResultMap).flatMap { Playlist(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "playlist")
      }
    }

    public struct Playlist: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Playlist"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("curator", type: .object(Curator.selections)),
          GraphQLField("display", type: .object(Display.selections)),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("shortDescription", type: .scalar(String.self)),
          GraphQLField("genres", arguments: ["first": 1000], type: .object(Genre.selections)),
          GraphQLField("tracks", arguments: ["first": 1000, "market": "GB"], type: .object(Track.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String, curator: Curator? = nil, display: Display? = nil, description: String? = nil, shortDescription: String? = nil, genres: Genre? = nil, tracks: Track? = nil) {
        self.init(unsafeResultMap: ["__typename": "Playlist", "name": name, "curator": curator.flatMap { (value: Curator) -> ResultMap in value.resultMap }, "display": display.flatMap { (value: Display) -> ResultMap in value.resultMap }, "description": description, "shortDescription": shortDescription, "genres": genres.flatMap { (value: Genre) -> ResultMap in value.resultMap }, "tracks": tracks.flatMap { (value: Track) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      /// The curator of the playlist
      public var curator: Curator? {
        get {
          return (resultMap["curator"] as? ResultMap).flatMap { Curator(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "curator")
        }
      }

      public var display: Display? {
        get {
          return (resultMap["display"] as? ResultMap).flatMap { Display(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "display")
        }
      }

      public var description: String? {
        get {
          return resultMap["description"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }

      public var shortDescription: String? {
        get {
          return resultMap["shortDescription"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "shortDescription")
        }
      }

      public var genres: Genre? {
        get {
          return (resultMap["genres"] as? ResultMap).flatMap { Genre(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "genres")
        }
      }

      public var tracks: Track? {
        get {
          return (resultMap["tracks"] as? ResultMap).flatMap { Track(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "tracks")
        }
      }

      public struct Curator: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Curator"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Curator", "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The curator's name
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }

      public struct Display: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Display"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("image", type: .object(Image.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(image: Image? = nil) {
          self.init(unsafeResultMap: ["__typename": "Display", "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var image: Image? {
          get {
            return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "image")
          }
        }

        public struct Image: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Image"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("placeholder", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(placeholder: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Image", "placeholder": placeholder])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var placeholder: String? {
            get {
              return resultMap["placeholder"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "placeholder")
            }
          }
        }
      }

      public struct Genre: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PlaylistGenresConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge]) {
          self.init(unsafeResultMap: ["__typename": "PlaylistGenresConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var edges: [Edge] {
          get {
            return (resultMap["edges"] as! [ResultMap]).map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Edge) -> ResultMap in value.resultMap }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PlaylistGenresEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .nonNull(.object(Node.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node) {
            self.init(unsafeResultMap: ["__typename": "PlaylistGenresEdge", "node": node.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var node: Node {
            get {
              return Node(unsafeResultMap: resultMap["node"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["PlaylistGenre"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String) {
              self.init(unsafeResultMap: ["__typename": "PlaylistGenre", "name": name])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }
          }
        }
      }

      public struct Track: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PlaylistTracksConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .nonNull(.list(.nonNull(.object(Edge.selections))))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge]) {
          self.init(unsafeResultMap: ["__typename": "PlaylistTracksConnection", "edges": edges.map { (value: Edge) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var edges: [Edge] {
          get {
            return (resultMap["edges"] as! [ResultMap]).map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) }
          }
          set {
            resultMap.updateValue(newValue.map { (value: Edge) -> ResultMap in value.resultMap }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PlaylistTracksEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .nonNull(.object(Node.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node) {
            self.init(unsafeResultMap: ["__typename": "PlaylistTracksEdge", "node": node.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var node: Node {
            get {
              return Node(unsafeResultMap: resultMap["node"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Track"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("title", type: .nonNull(.scalar(String.self))),
                GraphQLField("artists", type: .list(.nonNull(.object(Artist.selections)))),
                GraphQLField("album", type: .object(Album.selections)),
                GraphQLField("explicit", type: .scalar(Bool.self)),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("isrc", type: .scalar(String.self)),
                GraphQLField("previewUrl", type: .scalar(String.self)),
                GraphQLField("recognizability", type: .scalar(Int.self)),
                GraphQLField("display", type: .object(Display.selections)),
                GraphQLField("shareUrl", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(title: String, artists: [Artist]? = nil, album: Album? = nil, explicit: Bool? = nil, id: GraphQLID, isrc: String? = nil, previewUrl: String? = nil, recognizability: Int? = nil, display: Display? = nil, shareUrl: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Track", "title": title, "artists": artists.flatMap { (value: [Artist]) -> [ResultMap] in value.map { (value: Artist) -> ResultMap in value.resultMap } }, "album": album.flatMap { (value: Album) -> ResultMap in value.resultMap }, "explicit": explicit, "id": id, "isrc": isrc, "previewUrl": previewUrl, "recognizability": recognizability, "display": display.flatMap { (value: Display) -> ResultMap in value.resultMap }, "shareUrl": shareUrl])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var title: String {
              get {
                return resultMap["title"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "title")
              }
            }

            public var artists: [Artist]? {
              get {
                return (resultMap["artists"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Artist] in value.map { (value: ResultMap) -> Artist in Artist(unsafeResultMap: value) } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [Artist]) -> [ResultMap] in value.map { (value: Artist) -> ResultMap in value.resultMap } }, forKey: "artists")
              }
            }

            public var album: Album? {
              get {
                return (resultMap["album"] as? ResultMap).flatMap { Album(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "album")
              }
            }

            public var explicit: Bool? {
              get {
                return resultMap["explicit"] as? Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "explicit")
              }
            }

            public var id: GraphQLID {
              get {
                return resultMap["id"]! as! GraphQLID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }

            /// A globally unique ID to identify this recording
            public var isrc: String? {
              get {
                return resultMap["isrc"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "isrc")
              }
            }

            /// A 30 second preview of the track. Not available for all tracks
            public var previewUrl: String? {
              get {
                return resultMap["previewUrl"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "previewUrl")
              }
            }

            /// The recognizability of this track (0-100)
            public var recognizability: Int? {
              get {
                return resultMap["recognizability"] as? Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "recognizability")
              }
            }

            public var display: Display? {
              get {
                return (resultMap["display"] as? ResultMap).flatMap { Display(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "display")
              }
            }

            /// A URL that can be used to share the track with users. Does not necessarily always point to the same provider (e.g. Spotify)
            @available(*, deprecated, message: "Will be removed in a future version.")
            public var shareUrl: String? {
              get {
                return resultMap["shareUrl"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "shareUrl")
              }
            }

            public struct Artist: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Artist"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(name: String) {
                self.init(unsafeResultMap: ["__typename": "Artist", "name": name])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var name: String {
                get {
                  return resultMap["name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }
            }

            public struct Album: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Album"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("title", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(title: String) {
                self.init(unsafeResultMap: ["__typename": "Album", "title": title])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var title: String {
                get {
                  return resultMap["title"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "title")
                }
              }
            }

            public struct Display: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Display"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("image", type: .object(Image.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(image: Image? = nil) {
                self.init(unsafeResultMap: ["__typename": "Display", "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var image: Image? {
                get {
                  return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "image")
                }
              }

              public struct Image: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Image"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("placeholder", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(placeholder: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Image", "placeholder": placeholder])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var placeholder: String? {
                  get {
                    return resultMap["placeholder"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "placeholder")
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class SearchQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Search($query: String!, $type: SearchType!) {
      search(first: 1000, query: $query, type: $type) {
        __typename
        edges {
          __typename
          node {
            __typename
            ... on Playlist {
              __typename
              id
              name
              display {
                __typename
                image {
                  __typename
                  placeholder
                }
              }
              shortDescription
            }
          }
        }
      }
    }
    """

  public let operationName: String = "Search"

  public var query: String
  public var type: SearchType

  public init(query: String, type: SearchType) {
    self.query = query
    self.type = type
  }

  public var variables: GraphQLMap? {
    return ["query": query, "type": type]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("search", arguments: ["first": 1000, "query": GraphQLVariable("query"), "type": GraphQLVariable("type")], type: .object(Search.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(search: Search? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "search": search.flatMap { (value: Search) -> ResultMap in value.resultMap }])
    }

    /// Search for one of `playlists`, `albums` and `artists` and `tracks`.
    public var search: Search? {
      get {
        return (resultMap["search"] as? ResultMap).flatMap { Search(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SearchResultConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .list(.object(Edge.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(edges: [Edge?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "SearchResultConnection", "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var edges: [Edge?]? {
        get {
          return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SearchResultEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(node: Node? = nil) {
          self.init(unsafeResultMap: ["__typename": "SearchResultEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var node: Node? {
          get {
            return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Track", "Artist", "Album", "Soundtrack", "Playlist", "BrowseCategory"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLTypeCase(
                variants: ["Playlist": AsPlaylist.selections],
                default: [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                ]
              )
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public static func makeTrack() -> Node {
            return Node(unsafeResultMap: ["__typename": "Track"])
          }

          public static func makeArtist() -> Node {
            return Node(unsafeResultMap: ["__typename": "Artist"])
          }

          public static func makeAlbum() -> Node {
            return Node(unsafeResultMap: ["__typename": "Album"])
          }

          public static func makeSoundtrack() -> Node {
            return Node(unsafeResultMap: ["__typename": "Soundtrack"])
          }

          public static func makeBrowseCategory() -> Node {
            return Node(unsafeResultMap: ["__typename": "BrowseCategory"])
          }

          public static func makePlaylist(id: GraphQLID, name: String, display: AsPlaylist.Display? = nil, shortDescription: String? = nil) -> Node {
            return Node(unsafeResultMap: ["__typename": "Playlist", "id": id, "name": name, "display": display.flatMap { (value: AsPlaylist.Display) -> ResultMap in value.resultMap }, "shortDescription": shortDescription])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asPlaylist: AsPlaylist? {
            get {
              if !AsPlaylist.possibleTypes.contains(__typename) { return nil }
              return AsPlaylist(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsPlaylist: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Playlist"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
                GraphQLField("display", type: .object(Display.selections)),
                GraphQLField("shortDescription", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID, name: String, display: Display? = nil, shortDescription: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Playlist", "id": id, "name": name, "display": display.flatMap { (value: Display) -> ResultMap in value.resultMap }, "shortDescription": shortDescription])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var id: GraphQLID {
              get {
                return resultMap["id"]! as! GraphQLID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }

            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            public var display: Display? {
              get {
                return (resultMap["display"] as? ResultMap).flatMap { Display(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "display")
              }
            }

            public var shortDescription: String? {
              get {
                return resultMap["shortDescription"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "shortDescription")
              }
            }

            public struct Display: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Display"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("image", type: .object(Image.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(image: Image? = nil) {
                self.init(unsafeResultMap: ["__typename": "Display", "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var image: Image? {
                get {
                  return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "image")
                }
              }

              public struct Image: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Image"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("placeholder", type: .scalar(String.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(placeholder: String? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Image", "placeholder": placeholder])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var placeholder: String? {
                  get {
                    return resultMap["placeholder"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "placeholder")
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class SearchForArtistStationQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query SearchForArtistStation($query: String!) {
      search(first: 1, query: $query, type: artist) {
        __typename
        edges {
          __typename
          node {
            __typename
            ... on Artist {
              __typename
              station {
                __typename
                id
                name
                display {
                  __typename
                  image {
                    __typename
                    placeholder
                  }
                }
                shortDescription
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "SearchForArtistStation"

  public var query: String

  public init(query: String) {
    self.query = query
  }

  public var variables: GraphQLMap? {
    return ["query": query]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("search", arguments: ["first": 1, "query": GraphQLVariable("query"), "type": "artist"], type: .object(Search.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(search: Search? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "search": search.flatMap { (value: Search) -> ResultMap in value.resultMap }])
    }

    /// Search for one of `playlists`, `albums` and `artists` and `tracks`.
    public var search: Search? {
      get {
        return (resultMap["search"] as? ResultMap).flatMap { Search(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SearchResultConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .list(.object(Edge.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(edges: [Edge?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "SearchResultConnection", "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var edges: [Edge?]? {
        get {
          return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SearchResultEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(node: Node? = nil) {
          self.init(unsafeResultMap: ["__typename": "SearchResultEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var node: Node? {
          get {
            return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Track", "Artist", "Album", "Soundtrack", "Playlist", "BrowseCategory"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLTypeCase(
                variants: ["Artist": AsArtist.selections],
                default: [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                ]
              )
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public static func makeTrack() -> Node {
            return Node(unsafeResultMap: ["__typename": "Track"])
          }

          public static func makeAlbum() -> Node {
            return Node(unsafeResultMap: ["__typename": "Album"])
          }

          public static func makeSoundtrack() -> Node {
            return Node(unsafeResultMap: ["__typename": "Soundtrack"])
          }

          public static func makePlaylist() -> Node {
            return Node(unsafeResultMap: ["__typename": "Playlist"])
          }

          public static func makeBrowseCategory() -> Node {
            return Node(unsafeResultMap: ["__typename": "BrowseCategory"])
          }

          public static func makeArtist(station: AsArtist.Station? = nil) -> Node {
            return Node(unsafeResultMap: ["__typename": "Artist", "station": station.flatMap { (value: AsArtist.Station) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asArtist: AsArtist? {
            get {
              if !AsArtist.possibleTypes.contains(__typename) { return nil }
              return AsArtist(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsArtist: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Artist"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("station", type: .object(Station.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(station: Station? = nil) {
              self.init(unsafeResultMap: ["__typename": "Artist", "station": station.flatMap { (value: Station) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var station: Station? {
              get {
                return (resultMap["station"] as? ResultMap).flatMap { Station(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "station")
              }
            }

            public struct Station: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Playlist"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("display", type: .object(Display.selections)),
                  GraphQLField("shortDescription", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: GraphQLID, name: String, display: Display? = nil, shortDescription: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Playlist", "id": id, "name": name, "display": display.flatMap { (value: Display) -> ResultMap in value.resultMap }, "shortDescription": shortDescription])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: GraphQLID {
                get {
                  return resultMap["id"]! as! GraphQLID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }

              public var name: String {
                get {
                  return resultMap["name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }

              public var display: Display? {
                get {
                  return (resultMap["display"] as? ResultMap).flatMap { Display(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "display")
                }
              }

              public var shortDescription: String? {
                get {
                  return resultMap["shortDescription"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "shortDescription")
                }
              }

              public struct Display: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Display"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("image", type: .object(Image.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(image: Image? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Display", "image": image.flatMap { (value: Image) -> ResultMap in value.resultMap }])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var image: Image? {
                  get {
                    return (resultMap["image"] as? ResultMap).flatMap { Image(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "image")
                  }
                }

                public struct Image: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Image"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("placeholder", type: .scalar(String.self)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(placeholder: String? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Image", "placeholder": placeholder])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var placeholder: String? {
                    get {
                      return resultMap["placeholder"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "placeholder")
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
