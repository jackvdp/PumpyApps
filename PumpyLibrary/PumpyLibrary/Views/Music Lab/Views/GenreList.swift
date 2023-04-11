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
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var onlyShowSelected = false
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredgenres.indices, id: \.self) { i in
                        genreRow(filteredgenres[i])
                    }
                }
                .searchable(text: $searchText,
                            prompt: "Genres")
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    closeButton
                }
                ToolbarItem(placement: .primaryAction) {
                    filterButton
                }
            }
            .padding()
            .pumpyBackground()
            .navigationTitle("Genres")
        }
        .accentColor(.pumpyPink)
    }
    
    func genreRow(_ genre: String) -> some View {
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
        .buttonStyle(.bordered)
    }
    
    var closeButton: some View {
        Button("Close") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var filterButton: some View {
        Button {
            withAnimation {
                onlyShowSelected.toggle()
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle" + (onlyShowSelected ? ".fill" : ""))
        }
    }
    
    var filteredgenres: [String] {
        if onlyShowSelected {
            return labManager.genres.filter {
                labManager.selectedGenres.contains($0)
            }
        } else if searchText.isEmpty {
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
    }
    
    static var labManager: MusicLabManager {
        let lm = MusicLabManager()
        lm.getGenres(authManager: AuthorisationManager())
        return lm
    }
}
