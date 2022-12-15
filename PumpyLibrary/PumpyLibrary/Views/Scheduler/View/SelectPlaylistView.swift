//
//  SelectPlaylistView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 18/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

extension SetScheduleView {
    struct SelectPlaylistView: View {
        
        @ObservedObject var schVM: SetScheduleViewModel
        
        var body: some View {
            HStack {
                Text("Playlist:")
                Spacer()
                Picker(schVM.playlistIndex != nil ? schVM.playlists[schVM.playlistIndex!] : "Select Playlist", selection: $schVM.playlistIndex) {
                    Text("-- Select Playlist --").tag(nil as Int?)
                    ForEach(schVM.playlists.indices, id: \.self) { i in
                        Text(schVM.playlists[i]).tag(i as Int?)
                    }
                }
                .pickerStyle(.menu)
                .buttonStyle(.plain)
            }
        }
    }
    
    struct SelectSecondaryPlaylistView: View {
        
        @ObservedObject var schVM: SetScheduleViewModel
        @Binding var secondaryPlaylist: SecondaryPlaylist
        
        var body: some View {
            HStack {
                Text("Playlist:")
                Spacer()
                Picker("", selection: $secondaryPlaylist.name) {
                    ForEach(schVM.playlists, id: \.self) { playlist in
                        Text(playlist)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    struct SelectSecondaryRatioView: View {
        
        @ObservedObject var schVM: SetScheduleViewModel
        @Binding var secondaryPlaylist: SecondaryPlaylist
        var repeatInt = [2,3,4,5,6,7,8,9,10]
        
        var body: some View {
            HStack {
                Text("Play Once Every:")
                Spacer()
                Picker("", selection: $secondaryPlaylist.ratio) {
                    ForEach(repeatInt, id: \.self) { playlist in
                        Text("\(playlist)")
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
}

#if DEBUG
struct SelectPlaylistView_Previews: PreviewProvider {
    
    struct TestUser: ScheduledUser {
        var username: String = "Test"
        var alarmData = AlarmManager(username: "Test")
    }
    
    static var previews: some View {
        SetScheduleView.SelectPlaylistView(schVM: SetScheduleViewModel(alarm: nil,
                                                                       alarmManager: AlarmManager(username: "Test"),
                                                                       getPlists: {return[]}))
    }
}
#endif
