//
//  SetScheduleView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct SetScheduleView: View {
    
    @ObservedObject var schVM: SetScheduleViewModel
    @EnvironmentObject var alarmManager: AlarmManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert: Bool = false
    @State private var showingSecondaryPlaylists = true
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            PumpyList {
                playlistDetails
                secondaryPlaylists
                externalDisplaySettings
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Set Event")
            .navigationBarItems(leading: CancelButton(action: cancelPressed),
                                trailing: SaveButton(action: saveAlarm))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.pumpyPink)
        .alert(isPresented: $showingAlert) {
            playlistAlert
        }
    }
    
    // MARK: - Components
    
    var playlistDetails: some View {
        Section {
            DatePicker("Start Time:", selection: $schVM.selectedDate, displayedComponents: .hourAndMinute)
            SelectPlaylistView(schVM: schVM)
            NavigationLink(destination: SelectDaysView(selectedDays: $schVM.days)) {
                FormViewRow(title: "Days:", subTitle: schVM.days.uiString)
            }
        }
    }
    
    var secondaryPlaylists: some View {
        Section(header:
                    HStack {
                        Text("Secondary Playlists")
                        Spacer()
                             Button(action: {
                                 schVM.createNewSecondaryPlaylist()
                             }, label: {
                                 Image(systemName: "plus.circle")
                             })
                    }
                    ) {
            ForEach($schVM.secondaryPlaylists) { playlist in
                Section {
                    VStack {
                        SelectSecondaryPlaylistView(schVM: schVM, secondaryPlaylist: playlist)
                        SelectSecondaryRatioView(schVM: schVM, secondaryPlaylist: playlist)
                    }
                }
            }
            .onDelete(perform: deleteSecondaryPlaylist)
        }
    }
    
    var externalDisplaySettings: some View {
        Section {
            DisclosureGroup("External Display Settings",
                            isExpanded: $schVM.externalSettingsOverride) {
                ExtDisplaySettingsRows(displayContent: $schVM.contentType,
                                   showQRCode: $schVM.showQRCode,
                                   qrURL: $schVM.qrLink,
                                   marqueeTextLabel: $schVM.qrMessage,
                                   marqueeSpeed: $schVM.messageSpeed,
                                   qrType: $schVM.qrType)
            }
        }
    }
    
    var playlistAlert: Alert {
        Alert(title: Text("Select Playlist"),
              message: Text("Please select a playlist to save event"),
              dismissButton: .default(Text("Got it!")))
    }
    
    // MARK: - Methods
    
    func saveAlarm() {
        if schVM.playlistIndex != nil {
            schVM.saveAlarm()
            presentationMode.wrappedValue.dismiss()
        } else {
            showingAlert = true
        }
    }
    
    func cancelPressed() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func deleteSecondaryPlaylist(at offsets: IndexSet) {
        offsets.forEach { i in
            schVM.secondaryPlaylists.remove(at: i)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct SetScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        return SetScheduleView(schVM:
                                SetScheduleViewModel(alarm: nil,
                                                     alarmManager: AlarmManager(username: "Test", preview: true),
                                                     getPlists: {return []})
        )
    }
}
#endif
