//
//  GenreList.swift
//  PumpyLibrary
//
//  Created by Jack Vanderpump on 11/04/2023.
//

import SwiftUI
import PumpyAnalytics

struct GenreList: View {
    @EnvironmentObject var labManager: MusicLabManager
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            PumpyList {
                ForEach(filteredgenres.indices, id: \.self) { i in
                    let genre = filteredgenres[i]
                    Button {
                        labManager.addRemoveGenre(genre)
                    } label: {
                        HStack {
                            Text(genre)
                            Spacer()
                            if labManager.selectedGenres.contains(genre) {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.pumpyPink)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Genres")
            .searchable(text: $searchText,
                        prompt: "Genres")
        }
        .pumpyBackground()
    }
    
    var filteredgenres: [String] {
        if searchText.isEmpty {
            return labManager.genres
        } else {
            return labManager.genres.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct GenreList_Previews: PreviewProvider {
    static var previews: some View {
        GenreList()
            .environmentObject(labManager)
            .preferredColorScheme(.dark)
            .accentColor(.pumpyPink)
    }
    
    static var labManager: MusicLabManager {
        let lm = MusicLabManager()
        lm.getGenres(authManager: AuthorisationManager())
        return lm
    }
}
