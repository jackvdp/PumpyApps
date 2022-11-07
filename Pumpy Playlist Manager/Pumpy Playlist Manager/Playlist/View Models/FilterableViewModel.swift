//
//  PlayableViewModel.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 27/07/2022.
//

import SwiftUI
import PumpyAnalytics

class FilterableViewModel: ObservableObject {
    
    var playlist: Playlist {
        didSet {
            setDisplayedTracks()
        }
    }
    
    init(_ playlist: Playlist) {
        self.playlist = playlist
        displayedTracks = playlist.tracks
        setDisplayedTracks()
    }
    
    @Published var displayedTracks: [Track]
    
    // MARK: - Genres
    
    @Published var genres = [String?]()
    
    @Published var unwantedGenres = [String?]() {
        didSet {
            setDisplayedTracks()
        }
    }
    
    func getGenres() {
        let tracksGenres: [[String?]] = playlist.tracks.map { $0.appleMusicItem?.genres ?? [nil] }
        genres = Array(Set(tracksGenres.flatMap { $0 }))
        genres.sort(by: { $0 ?? "zz" < $1 ?? "zz" })
    }
    
    // MARK: - Sort/filter
    var searchTerm = String() {
        didSet {
            setDisplayedTracks()
        }
    }
    
    @Published var ascending = false {
        didSet {
            setDisplayedTracks()
        }
    }
    
    @Published var sortBy = SortTracks.standard {
        didSet {
            setDisplayedTracks()
        }
    }
    
    // MARK: - Set displayed tracks
    
    func setDisplayedTracks() {
        let wantedGenreTracks = removeUnwantedGenres(tracks: playlist.tracks)
        let searchedTracks = filterTracks(tracks: wantedGenreTracks)
        displayedTracks = SortPlaylistModel(sortBy: sortBy, tracks: searchedTracks, ascending: ascending).sortTracks()
    }
    
    private func filterTracks(tracks: [Track]) -> [Track] {
        guard searchTerm != String() else { return tracks }
        let searchText = searchTerm.lowercased()
        
        return tracks.filter {
            let argumentTitle = $0.title.lowercased()
            let argumentArtist = $0.artist.lowercased()

            return argumentTitle.lowercased().contains(searchText) || argumentArtist.contains(searchText)
        }
    }
    
    private func removeUnwantedGenres(tracks: [Track]) -> [Track] {
        if unwantedGenres.isEmpty {
            return tracks
        } else {
            var wantedTracks = [Track]()
            let wantedGenres = genres.filter { !unwantedGenres.contains($0) }
            
            for track in tracks {
                let trackGenres: [String?] = track.appleMusicItem?.genres ?? [nil]
                if wantedGenres.contains(where: { trackGenres.contains($0) }) {
                    wantedTracks.append(track)
                }
            }
            
            return wantedTracks
        }
    }
    
}
