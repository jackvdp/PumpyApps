//
//  Apollo.swift
//  GraphQL Test
//
//  Created by Jack Vanderpump on 10/02/2022.
//

import Foundation
import Apollo

public class ApolloClass {
    
    static public let shared = ApolloClass()
    public let client: ApolloClient

    private init() {
      client = ApolloClient(url: URL(string: "https://api.soundtrackyourbrand.com/v2")!)
    }
}
