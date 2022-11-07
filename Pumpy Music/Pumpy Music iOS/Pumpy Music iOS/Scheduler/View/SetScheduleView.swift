//
//  SetScheduleView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary

struct SetScheduleView: View {
    
    @EnvironmentObject var schVM: ScheduleViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert: Bool = false
    @State private var showingSecondaryPlaylists = true
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            List {
                Section {
                    DatePicker("Start Time:", selection: $schVM.selectedDate, displayedComponents: .hourAndMinute)
                    SelectPlaylistView()
                    NavigationLink(destination: SelectDaysView(selectedDays: $schVM.days)) {
                        FormViewRow(title: "Days:", subTitle: schVM.days.uiString)
                    }
                }
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
                                SelectSecondaryPlaylistView(secondaryPlaylist: playlist)
                                SelectSecondaryRatioView(secondaryPlaylist: playlist)
                            }
                        }
                    }
                    .onDelete(perform: deleteSecondaryPlaylist)
                }
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
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(leading: CancelButton() { cancelPressed() },
                                trailing: SaveButton(action: saveAlarm))
            .navigationTitle("Set Event")
        }
        .onAppear() {
            schVM.setAlarm()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(.pumpyPink)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Select Playlist"),
                  message: Text("Please select a playlist to save event"),
                  dismissButton: .default(Text("Got it!")))
        }
    }
    
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

#if DEBUG
struct SetScheduleView_Previews: PreviewProvider {
    struct TestUser: ScheduledUser {
        var username: String = "Test"
        var alarmData = AlarmData(username: "Test")
    }
    
    static let schVM = ScheduleViewModel(user: TestUser(), getPlists: {return []})
    
    static var previews: some View {
        schVM.externalSettingsOverride = true
        schVM.secondaryPlaylists = [SecondaryPlaylist(name: "A Bit of Lunch", ratio: 5)]
        return SetScheduleView()
            .environmentObject(schVM)
    }
}
#endif
