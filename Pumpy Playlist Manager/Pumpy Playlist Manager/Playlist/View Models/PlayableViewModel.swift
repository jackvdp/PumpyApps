//
//  PlayableViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 02/08/2022.
//

import Foundation
import PumpyAnalytics

protocol PlayableViewModel: ObservableObject {
    var playlist: Playlist { get set }
    func getCorrectSnapshot() -> PlaylistSnapshot
    func deleteTracks(selectedTracks: Set<Track>)
}
