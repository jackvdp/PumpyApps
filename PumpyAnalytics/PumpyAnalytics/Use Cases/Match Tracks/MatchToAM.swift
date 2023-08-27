//
//  MatchToAM.swift
//  PumpyAnalytics
//
//  Created by Jack Vanderpump on 31/07/2022.
//

import Foundation
import PumpyShared

class MatchToAM {
     
    private let gateway = AMTracksAPI()
    
    /// Match tracks to Apple Music
    /// - Parameters:
    ///   - tracks: Tracks to get matched to Apple Music.
    ///   - authManager: AuthorisationManager object.
    ///   - chunkSize: Max size of 25. 10 to reduce incidence of 504 errors
    func execute(tracks: [Track], authManager: AuthorisationManager, chunkSize: Int = 10) async {
        let unmatchedTracks = tracks.filter { $0.appleMusicItem == nil }
        unmatchedTracks.forEach { $0.inProgress.gettingAM = true }
        let trackPacks = unmatchedTracks.chunks(chunkSize)
        
        await trackPacks.asyncForEach { pack in
            guard !Task.isCancelled else { print("Matching task cancelled"); return }
            
            let isrcs = pack.compactMap { $0.isrc }.joined(separator: ",")
            
            let (items, code) = await gateway.getAppleItemFromISRCs(isrcs: isrcs, authManager: authManager)
            
            if code == 504 {
                
                // Gateway timeout error thrown when server is too slow to respond.
                // Solution is to break it up into smaller chunks
                // If it's two or less then assume issue with individual ISRC and give up
                if chunkSize > 2 {
                    await execute(tracks: pack, authManager: authManager, chunkSize: chunkSize / 2 + 1)
                }
                
            } else {
                
                for track in pack {
                    matchTrackToItem(track: track,
                                     items: items,
                                     authManager: authManager)
                }
                
            }
        }
    }
    
    private func matchTrackToItem(track: Track, items: [AppleMusicItem], authManager: AuthorisationManager) {
        DispatchQueue.main.async {
            if let item = items.first(where: { $0.isrc == track.isrc }) {
                track.appleMusicItem = item
            } else {
                track.inProgress.gettingAM = false
            }
        }
    }
    
}

//    MARK: - If want to reinstate the search for track after not getting it for ISRCS
    
//    To put back in the matchTrackToItem func else block
    //            gateway.searchForID(formattedTrackForSearch: formatItemForSearch("\(track.title) \(track.artist)"),
    //                                authManager: authManager) { items in
    //                self.matchTrackToSearchItem(track: track, items: items)
    //            }
        
//    private func matchTrackToSearchItem(track: Track, items: [AppleMusicItem]) {
//        if !items.isEmpty {
//            let formattedTrackName = formatStringForCompare(track.title)
//            let formattedTrackArtist = formatStringForCompare(track.artist)
//            for item in items {
//                let formattedItemName = formatStringForCompare(item.name)
//                let formattedItemArtist = formatStringForCompare(item.artistName)
//                if track.isrc == item.isrc || (formattedTrackArtist == formattedItemArtist && formattedTrackName == formattedItemName) {
//                    track.appleMusicItem = item
//                    MatchNotification().post()
//                    return
//                }
//            }
//        }
//        track.inProgress.gettingAM = false
//    }
//
//    private func formatItemForSearch(_ term: String) -> String {
//        var newTerm = term.lowercased()
//        newTerm.removeAll(where: { $0 == "[" || $0 == "]" || $0 == "(" || $0 == ")" })
//        return newTerm
//    }
//
//    private func formatStringForCompare(_ term: String) -> String {
//        var newTerms = formatItemForSearch(term).split(whereSeparator: {$0 == " "})
//        newTerms.removeAll(where: { $0 == "&" || $0 == "and" })
//        let sortedTerms = newTerms.sorted(by: { $0 < $1 })
//        return sortedTerms.joined(separator: " ")
//    }
