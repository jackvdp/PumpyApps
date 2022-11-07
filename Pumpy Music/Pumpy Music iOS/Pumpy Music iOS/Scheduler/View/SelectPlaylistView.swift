//
//  SelectPlaylistView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 18/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary

extension SetScheduleView {
    struct SelectPlaylistView: View {
        
        @EnvironmentObject var schVM: ScheduleViewModel
        
        var body: some View {
            if #available(iOS 15, *) {
                HStack {
                    Text("Playlist:")
                    Spacer()
                    Picker(schVM.playlistIndex != nil ? schVM.playlists[schVM.playlistIndex!] : "Select Playlist", selection: $schVM.playlistIndex) {
                        Text("-- Select Playlist --").tag(nil as Int?)
                        ForEach(0 ..< schVM.playlists.count) { i in
                            Text(schVM.playlists[i]).tag(i as Int?)
                        }
                    }
                    .pickerStyle(.menu)
                    .buttonStyle(.plain)
                }
            } else {
                Picker(selection: $schVM.playlistIndex, label:
                        FormViewRow(title: "Playlist:", subTitle: schVM.playlistIndex != nil ? schVM.playlists[schVM.playlistIndex!] : "Select Playlist")
                ) {
                    Text("-- Select Playlist --").tag(nil as Int?)
                    ForEach(0 ..< schVM.playlists.count) { i in
                        Text(schVM.playlists[i]).tag(i as Int?)
                    }
                }.pickerStyle(MenuPickerStyle())
                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    struct SelectSecondaryPlaylistView: View {
        
        @EnvironmentObject var schVM: ScheduleViewModel
        @Binding var secondaryPlaylist: SecondaryPlaylist
        
        var body: some View {
            if #available(iOS 15, *) {
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
            } else {
                Picker(selection: $secondaryPlaylist.name, label:
                        FormViewRow(title: "Playlist:", subTitle: secondaryPlaylist.name)
                ) {
                    ForEach(schVM.playlists, id: \.self) { playlist in
                        Text(playlist)
                    }
                }.pickerStyle(MenuPickerStyle())
                    .buttonStyle(PlainButtonStyle())
            }
            
        }
    }
    
    struct SelectSecondaryRatioView: View {
        
        @EnvironmentObject var schVM: ScheduleViewModel
        @Binding var secondaryPlaylist: SecondaryPlaylist
        var repeatInt = [2,3,4,5,6,7,8,9,10]
        
        var body: some View {
            if #available(iOS 15, *) {
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
            } else {
                Picker(selection: $secondaryPlaylist.ratio, label:
                        FormViewRow(title: "Play Once Every:", subTitle: "\(secondaryPlaylist.ratio) tracks")
                ) {
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
        var alarmData = AlarmData(username: "Test")
    }
    
    static var previews: some View {
        SetScheduleView.SelectPlaylistView()
            .environmentObject(ScheduleViewModel(user: TestUser(), getPlists: {return []}))
    }
}
#endif
