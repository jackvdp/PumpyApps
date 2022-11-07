//
//  UpNextView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import MediaPlayer

public struct UpNextView<Q: QueueProtocol,
                         N:NowPlayingProtocol,
                         B:BlockedTracksProtocol,
                         T: TokenProtocol,
                         P:PlaylistProtocol>: View {
    
    @EnvironmentObject var queueManager: Q
    var fontStyle: Font
    var subFontOpacity: Double
    var showButton: Bool
    
    public var body: some View {
        ScrollViewReader { proxy in
            List {
                if queueManager.queueTracks.isNotEmpty && queueManager.queueIndex > 0 {
                    history
                }
                if queueManager.queueIndex < queueManager.queueTracks.count {
                    nowPlaying
                }
                if queueManager.queueIndex + 1 < queueManager.queueTracks.count {
                    playingNext
                }
                if queueManager.queueTracks.isEmpty {
                    nothingPlaying
                }
            }
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .clearListBackgroundIOS16()
            .onChange(of: queueManager.queueIndex) { tracks in
                scroll(proxy)
            }
            .onAppear() {
                scroll(proxy)
                // For iOS 15
                UITableView.appearance().backgroundColor = UIColor.clear
                UITableViewCell.appearance().backgroundColor = UIColor.clear
            }
            .mask(UpNextMask())
            
        }
    }
    
    // MARK: Methods
  
    func scroll(_ proxy: ScrollViewProxy) {
        if let track = queueManager.queueTracks[safe: queueManager.queueIndex + 1] {
            withAnimation {
                proxy.scrollTo(track.playbackStoreID, anchor: .top)
            }
        }
    }
    
    func removeRowsFromUpNext(at offsets: IndexSet) {
        for i in offsets {
            if queueManager.queueTracks.indices.contains(i) {
                let track = queueManager.queueTracks[i]
                queueManager.queueTracks.remove(at: i)
                queueManager.removeFromQueue(id: track.playbackStoreID)
            }
        }
    }
    
    // MARK: Components
    
    var history: some View {
        Section(header: Text("History")) {
            ForEach(0..<queueManager.queueIndex, id: \.self) { i in
                TrackRow<T,N,B,P,Q>(track: queueManager.queueTracks[i])
                    .deleteDisabled(true)
                    .foregroundColor(.white)
                    .id(queueManager.queueTracks[i].playbackStoreID)
            }
            .listRowBackground(Color.clear)
            .animation(.easeIn(duration: 0.5), value: queueManager.queueIndex)
        }
    }
    
    var nowPlaying: some View {
        Section(header: Text("Now Playing")) {
            TrackRow<T,N,B,P,Q>(track: queueManager.queueTracks[queueManager.queueIndex])
                .deleteDisabled(true)
                .foregroundColor(.white)
                .id(queueManager.queueTracks[queueManager.queueIndex].playbackStoreID)
        }
        .listSectionSeparator(Visibility.visible)
        .listRowBackground(Color.clear)
        .animation(.easeIn(duration: 0.5), value: queueManager.queueIndex)
    }
    
    var nothingPlaying: some View {
        Section(header: Text("")) {
            Text("Play something!")
                .font(.title)
                .frame(maxWidth: .infinity)
            .deleteDisabled(true)
            .foregroundColor(.white)
        }
        .listSectionSeparator(Visibility.visible)
        .listRowBackground(Color.clear)
        .animation(.easeIn(duration: 0.5), value: queueManager.queueIndex)
    }
    
    var playingNext: some View {
        Section(header: Text("Playing Next")) {
           ForEach(queueManager.queueIndex + 1..<queueManager.queueTracks.count, id: \.self) { i in
               TrackRow<T,N,B,P,Q>(track: queueManager.queueTracks[i])
                   .foregroundColor(.white)
                   .id(queueManager.queueTracks[i].playbackStoreID)
           }
           .onDelete { indexSet in
               removeRowsFromUpNext(at: indexSet)
           }
           .listRowBackground(Color.clear)
           .animation(.easeIn(duration: 0.5), value: queueManager.queueIndex)
       }
    }
}

#if DEBUG
struct UpNextView_Previews: PreviewProvider {
    
    static let queueManager = MockQueueManager()
    
    static var previews: some View {
        
        queueManager.queueTracks = Array(repeating: MockData.track, count: 30)
        
        return UpNextView<
            MockQueueManager,
            MockNowPlayingManager,
            MockBlockedTracks,
            MockTokenManager,
        MockPlaylistManager
        >()
            .environmentObject(queueManager)
            .environmentObject(MockBlockedTracks())
            .environmentObject(MockNowPlayingManager())
            .environmentObject(MockTokenManager())
            .environmentObject(MockPlaylistManager())
            .preferredColorScheme(.dark)
            .background(Color.indigo)
    }
}
#endif

public struct UpNextMask: View {
    
    public init() {}
    
    public var body: some View {
        LinearGradient(
            gradient:
                Gradient(colors:
                            Array<Color>(repeating: .white, count: 12) + Array<Color>(repeating: .white.opacity(0), count: 1)),
            startPoint: .top,
            endPoint: .bottom)
    }
}

extension UpNextView {
    public init(fontStyle: Font = .subheadline,
                opacity: Double = 1.0,
                showButton: Bool = true) {
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
        self.fontStyle = fontStyle
        self.subFontOpacity = opacity
        self.showButton = showButton
    }
}

struct ClearListBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

extension View {
    public func clearListBackgroundIOS16() -> some View {
        modifier(ClearListBackground())
    }
}
