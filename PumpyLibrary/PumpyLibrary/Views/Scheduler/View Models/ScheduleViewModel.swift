//
//  ScheduleViewModel.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 20/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

class ScheduleViewModel: ObservableObject {
    
    @Published var alarmsToDisplay = [Alarm]()
    @Published var alarmDays: DetailInfo.DaysOfWeek?
    @Published var showSetScheduleSheet = false
    @Published var selectedAlarm: Alarm?
    
    func setAndShowAlarm(_ alarm: Alarm?) {
        selectedAlarm = alarm
        showSetScheduleSheet = true
    }
    
    func filterAlarms(alarmArray: [Alarm]) {
        guard let day = alarmDays else { alarmsToDisplay = alarmArray; return }
        alarmsToDisplay = alarmArray.filter {
            if $0.repeatStatus.isEmpty { return true }
            return $0.repeatStatus.contains(day)
        }
    }
}
