//
//  MusicLabManager.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 09/03/2023.
//

import Foundation
import PumpyAnalytics
import SwiftUI
import PumpyShared

public class MusicLabManager: ObservableObject {

    public init() {}
    
    var properties = SeedAttributes.defaultAttributes()
    private let playlistController = PlaylistController()
    /// Is search view triggered by LabView. If so search should be dimssied rather than navigation to
    var searchViewTriggeredFromLab = false
    
    // MARK: - Create
    
    func createMix(authManager: AuthorisationManager, completion: @escaping (RecommendedPlaylist?) -> ()) {
        let seeding = properties.transformToAnalyticsSeeding(tracks: seedTracks, genres: selectedGenres)
        
        var name: String  {
            if seedTracks.isEmpty && selectedGenres.isEmpty { return "Music Lab Mix" } else {
                let artistsAndGenres = [seedTracks.map { "\($0.artist)" }.removingDuplicates(), selectedGenres].flatMap { $0 }
                return "\(artistsAndGenres.joined(separator: "/")) Mix"
            }
        }
        let artworkURL: String? = seedTracks.compactMap { $0.artworkURL }.first
        
        playlistController.createFromSuggestions(seeding: seeding,
                                                 playlistName: name,
                                                 artworkURL: artworkURL,
                                                 authManager: authManager) { playlist, error in
            completion(playlist)
            playlist?.getTracksData()
        }
    }
    
    // MARK: - Seed Items
    
    /// API only allows for a maximum of 5 seed items (tracks, artists, genres)
    var seedItemsTotal: Int {
        seedTracks.count + selectedGenres.count
    }
    
    // MARK: - Seed Tracks
    
    @Published private(set) var seedTracks = [PumpyAnalytics.Track]() {
        didSet {
            setAverages()
        }
    }
    
    /// Add new track to seed items. If seed tracks is already at capacity (count of 5), the first item will be removed
    func addTrack(_ track: PumpyAnalytics.Track) {
        seedTracks.append(track)
        
        if seedItemsTotal > 5 {
            if seedTracks.isNotEmpty {
                seedTracks.removeFirst()
            } else if selectedGenres.isNotEmpty {
                selectedGenres.removeFirst()
            }
        }
    }
    
    func removeTrack(at offsets: IndexSet) {
        seedTracks.remove(atOffsets: offsets)
    }
    
    func removeTrack(_ track: PumpyAnalytics.Track) {
        seedTracks.removeAll { trk in
            track.sourceID == trk.sourceID
        }
    }
    
    func includes(track: PumpyAnalytics.Track) -> Bool {
        seedTracks.contains { trk in
            track.sourceID == trk.sourceID
        }
    }
    
    // MARK: -  Seed Genres
    
    private let genreController = GenreController()
    /// List of all genres available
    @Published var genres = [String]()
    /// Array of genres selected by user for lab
    @Published var selectedGenres = [String]()
    
    func getGenres(authManager: AuthorisationManager) {
        guard genres.isEmpty else { return }
        genres = GenreController.defaultGenres
        genreController.getGenres(authManager: authManager) { [weak self] newGenres in
            if newGenres.isNotEmpty {
                self?.genres = newGenres
            }
        }
    }
    
    /// Add new genre to selected genres. If selected genres is already at capacity (count of 5), the first item will be removed.
    /// If genre is already sleected then it's removed
    func addRemoveGenre(_ genre: String) {
        if selectedGenres.contains(genre) {
            selectedGenres.removeAll(where: { $0 == genre })
        } else {
            selectedGenres.append(genre)
            
            if seedItemsTotal > 5 {
                if selectedGenres.isNotEmpty {
                    selectedGenres.removeFirst()
                } else if seedTracks.isNotEmpty {
                    seedTracks.removeFirst()
                }
            }
        }
    }
    
    // MARK: - Set Attribute Sliders
    
    var anyTracksHaveFeatures: Bool {
        seedTracks.filter { $0.audioFeatures != nil }.isNotEmpty
    }
    
    /// When a seed track gets added or removed, the averages need to be recalculated
    func setAverages() {
        withAnimation {
            for property in properties {
                property.setAverage(tracks: seedTracks)
            }
        }
    }
    
    // MARK: - Enable/Disable Attributes
    
    func enableAllAttributes() {
        properties.forEach { attribute in
            attribute.active = true
        }
        objectWillChange.send()
    }
    
    func disableAllAttributes() {
        properties.forEach { attribute in
            attribute.active = false
        }
        objectWillChange.send()
    }
    
    var allTracksEnabled: Bool {
        properties.filter { $0.active == false }.count == 0
    }
    
    var allTracksDisabled: Bool {
        properties.filter { $0.active }.count == 0
    }
}


