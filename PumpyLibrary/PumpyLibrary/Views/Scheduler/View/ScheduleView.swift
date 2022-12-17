//
//  ScheduleView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

public struct ScheduleView: View {
    
    @StateObject var scheduleViewModel = ScheduleViewModel()
    @EnvironmentObject var alarmManager: AlarmManager
    let getPlists: () -> [ScheduledPlaylist]
    
    public init(getPlists: @escaping () -> [ScheduledPlaylist]) {
        self.getPlists = getPlists
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if scheduleViewModel.alarmsToDisplay.isEmpty {
                noAlarms
            } else {
                alarmList
            }
            hoverButtons
        }
        .navigationTitle("Schedule" + (scheduleViewModel.alarmDays != nil ? " – \(scheduleViewModel.alarmDays!.rawValue)" : ""))
        .navigationBarItems(trailing: addAlarmButton)
        .sheet(isPresented: $scheduleViewModel.showSetScheduleSheet) {
            SetScheduleView(schVM: SetScheduleViewModel(alarm: scheduleViewModel.selectedAlarm,
                                                        alarmManager: alarmManager,
                                                        getPlists: getPlists))
        }
        .onChange(of: scheduleViewModel.alarmDays) { _ in
            scheduleViewModel.filterAlarms(alarmArray: alarmManager.alarms)
        }
        .onReceive(alarmManager.$alarms) { _ in
            scheduleViewModel.filterAlarms(alarmArray: alarmManager.alarms)
        }
    }
    
    // MARK: Components
    
    var noAlarms: some View {
        Text("No Events")
            .foregroundColor(Color.gray)
            .font(.largeTitle)
            .frame(maxHeight: .infinity)
    }
    
    var alarmList: some View {
        PumpyList {
            ForEach(scheduleViewModel.alarmsToDisplay, id: \.uuid) { alarm in
                Button(action: {
                    scheduleViewModel.setAndShowAlarm(alarm)
                }) {
                    ScheduleRow(alarm: alarm)
                }
            }
            .onDelete(perform: delete)
        }
        .listStyle(.plain)
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            let alarm = scheduleViewModel.alarmsToDisplay[i]
            scheduleViewModel.alarmsToDisplay.remove(at: i)
            alarmManager.deleteAlarm(alarm: alarm)
        }
    }
    
    var hoverButtons: some View {
        HStack {
            DuplicateAlarmsView()
            Spacer()
            FilterDaysView(days: $scheduleViewModel.alarmDays)
        }
    }
    
    var addAlarmButton: some View {
        Button(action: {
            scheduleViewModel.setAndShowAlarm(nil)
        }) {
            Image(systemName: "plus")
        }
    }
    
}

#if DEBUG
struct ScheduleView_Previews: PreviewProvider {
    static let scheduleView = ScheduleView(getPlists: {return []})
    
    static var previews: some View {
        return NavigationView {
            scheduleView
        }
        .padding()
        .environmentObject(AlarmManager())
    }
}
#endif
