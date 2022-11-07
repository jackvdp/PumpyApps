//
//  ScheduleView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct ScheduleView: View {
    
    @StateObject var scheduleViewModel: ScheduleViewModel
    @State private var actionSegue = false
    
    public init(user: ScheduledUser,
                getPlists: @escaping () -> [ScheduledPlaylist]) {
        _scheduleViewModel = StateObject(
            wrappedValue:
                ScheduleViewModel(
                    user: user,
                    getPlists: getPlists))
    }
    
    public var body: some View {
        ZStack {
            if scheduleViewModel.alarmArrayToView.isEmpty {
                Text("No Events")
                    .foregroundColor(Color.gray)
                    .font(.largeTitle)
            } else {
                List {
                    ForEach(scheduleViewModel.alarmArrayToView, id: \.uuid) { alarmSingle in
                        Button(action: {
                            scheduleViewModel.index = scheduleViewModel.alarmArray.firstIndex(of: alarmSingle)
                            actionSegue = true
                        }) {
                            ScheduleRow(alarm: alarmSingle)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
            }
            FilterDaysView(days: $scheduleViewModel.alarmDays)
        }
        .navigationTitle("Schedule" + (scheduleViewModel.alarmDays != nil ? " – \(scheduleViewModel.alarmDays!.rawValue)" : ""))
        .navigationBarItems(trailing: Button(action: {
            scheduleViewModel.resetAlarm()
            actionSegue = true
        }) {
            Image(systemName: "plus")
        })
//        .navigationBarItems(trailing: Button(action: {
//            scheduleViewModel.copyAlarmsFromOtherUser(from: "threetuns@pumpymusic.co.uk")
//        }) {
//            Image(systemName: "link")
//        })
        .sheet(isPresented: $actionSegue) {
            SetScheduleView()
                .environmentObject(scheduleViewModel)
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            let alarm = scheduleViewModel.alarmArrayToView[i]
            if let index = scheduleViewModel.alarmArray.firstIndex(of: alarm) {
                scheduleViewModel.deleteData(at: index)
            }
        }
    }
    
}

#if DEBUG
struct ScheduleView_Previews: PreviewProvider {
    
    struct TestUser: ScheduledUser {
        var username: String = "Test"
        var alarmData = AlarmData(username: "Test")
    }
    
    static let scheduleView = ScheduleView(user: TestUser(), getPlists: {return []})
    
    static var previews: some View {
        return NavigationView {
            scheduleView
        }.padding()
    }
}
#endif
