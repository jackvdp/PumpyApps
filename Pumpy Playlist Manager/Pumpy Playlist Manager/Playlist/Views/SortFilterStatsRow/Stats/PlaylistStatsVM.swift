//
//  PlaylistStatsVM.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 03/08/2022.
//

import Foundation
import PumpyAnalytics

class PlaylistStatsViewModel: ObservableObject {
    
    let playlist: Playlist
    @Published var genres: [String]?
    @Published var tempo: String?
    @Published var peak: String?
    @Published var dance: String?
    @Published var energy: String?
    @Published var valence: String?
    @Published var loudness: String?
    @Published var instrumentalness: String?
    @Published var acousticness: String?
    @Published var liveliness: String?
    @Published var popularity: String?
    @Published var year: String?
    
    init(_ playlist: Playlist) {
        self.playlist = playlist
    }
    
    func getStats() {
        getGenres()
        getTempo()
        getPeak()
        getDance()
        getEnergy()
        getValence()
        getLoudness()
        getInstrumental()
        getAcoustic()
        getLiveliness()
        getPopularity()
        getYear()
    }
    
    func getGenres() {
        let compactGenres = playlist.tracks.compactMap { $0.appleMusicItem?.genres }
        let flattenedGenres = compactGenres.flatMap { $0 }
        var counts: [String:Int] = [:]
        flattenedGenres.forEach { counts[$0, default: 0] += 1 }
        var sorted = counts.sorted(by: { $0.value > $1.value })
        let upperLimit = sorted.count > 3 ? 3 : sorted.count
        
        for _ in 0..<upperLimit {
            genres?.append(sorted.removeFirst().key)
        }
    }
    
    func getTempo() {
        let features = playlist.tracks.compactMap { $0.audioFeatures?.tempo }
        let total = features.reduce(0, { $0 + $1 })
        let average = total / Float(features.count)
        tempo = Int(average).description
    }
    
    func getPeak() {
        let features = playlist.tracks.compactMap { $0.audioFeatures?.pumpyScore }
        let total = features.reduce(0, { $0 + $1 })
        let average = total / Float(features.count) * 100
        peak = Int(average).description + "%"
    }
    
    func getDance() {
        let features = playlist.tracks.compactMap { $0.audioFeatures?.danceability }
        let total = features.reduce(0, { $0 + $1 })
        let average = total / Float(features.count) * 100
        dance = Int(average).description + "%"
    }
    
    func getEnergy() {
        let features = playlist.tracks.compactMap { $0.audioFeatures?.energy }
        let total = features.reduce(0, { $0 + $1 })
        let average = total / Float(features.count) * 100
        energy = Int(average).description + "%"
    }
    
    func getValence() {
        let features = playlist.tracks.compactMap { $0.audioFeatures?.valence }
        let total = features.reduce(0, { $0 + $1 })
        let average = total / Float(features.count) * 100
        valence = Int(average).description + "%"
    }
    
    func getLoudness() {
        let features = playlist.tracks.compactMap { $0.audioFeatures?.loudness }
        let total = features.reduce(0, { $0 + $1 })
        let average = total / Float(features.count)
        loudness = Int(average).description
    }
    
    func getInstrumental() {
        let features = playlist.tracks.compactMap { $0.audioFeatures?.instrumentalness }
        let total = features.reduce(0, { $0 + $1 })
        let average = total / Float(features.count) * 100
        instrumentalness = Int(average).description + "%"
    }
    
    func getAcoustic() {
        let features = playlist.tracks.compactMap { $0.audioFeatures?.acousticness }
        let total = features.reduce(0, { $0 + $1 })
        let average = total / Float(features.count) * 100
        acousticness = Int(average).description + "%"
    }
    
    func getLiveliness() {
        let features = playlist.tracks.compactMap { $0.audioFeatures?.liveliness }
        let total = features.reduce(0, { $0 + $1 })
        let average = total / Float(features.count) * 100
        liveliness = Int(average).description + "%"
    }
    
    func getPopularity() {
        let features = playlist.tracks.compactMap { $0.spotifyItem?.popularity }
        let total = features.reduce(0, { $0 + $1 })
        let average = total / features.count
        popularity = average.description + "%"
    }
    
    func getYear() {
        let years = playlist.tracks.compactMap { $0.spotifyItem?.year }
        let yearsSorted = years.sorted()
        let earliest = yearsSorted.first?.description ?? ""
        let latest = yearsSorted.last?.description ?? ""
        year = earliest + " – " + latest
    }
    
}
