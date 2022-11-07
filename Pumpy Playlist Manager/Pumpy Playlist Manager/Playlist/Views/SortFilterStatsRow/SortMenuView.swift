//
//  SortMenuView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 18/02/2022.
//

import PumpyAnalytics
import SwiftUI

struct SortMenuView: View {
    
    @Binding var sortBy: SortTracks
    @Binding var ascending: Bool
    
    var body: some View {
        HStack {
            Picker("Sort by:", selection: $sortBy) {
                ForEach(SortTracks.allCases) { sortBy in
                    Text(sortBy.rawValue)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: 250)
            Picker("", selection: $ascending) {
                Image(systemName: "arrow.down")
                    .tag(false)
                Image(systemName: "arrow.up")
                    .tag(true)
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .frame(width: 50)
        }
    }
}

struct SortMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SortMenuView(sortBy: .constant(SortTracks.title), ascending: .constant(false))
    }
}
