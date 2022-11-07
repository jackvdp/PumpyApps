//
//  ExternalDisplayView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 16/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct ExternalDisplayView<A: AccountManagerProtocol, P:PlaylistProtocol,N:NowPlayingProtocol, Q:QueueProtocol,B:BlockedTracksProtocol,T:TokenProtocol>: View {
    
    @EnvironmentObject var accountManager: A
    
    public init() {}
    
    public var body: some View {
        if let user = accountManager.user {
            ExtHomeView<P,N,Q,B,T>()
                .environmentObject(user.musicManager)
                .environmentObject(user.externalDisplayManager)
        } else {
            ExtLoggedOffView()
        }
    }
}

#if DEBUG
struct ExternalDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ExternalDisplayView<MockAccountManager,MockPlaylistManager,MockNowPlayingManager,MockQueueManager,MockBlockedTracks,MockTokenManager>()
            .environmentObject(MockAccountManager())
            .previewLayout(.sizeThatFits)
            .frame(width: 1920, height: 1080)
    }
}
#endif
