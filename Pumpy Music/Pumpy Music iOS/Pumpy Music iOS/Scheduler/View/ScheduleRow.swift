//
//  ScheduleRow.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 17/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary

struct ScheduleRow: View {
    
    let alarm: Alarm
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5.0) {
                Text(alarm.playlistLabel)
                    .font(.title2)
                    .fontWeight(.regular)
                Text(alarm.time.timeString + ", " + alarm.repeatStatus.uiString)
            }
            Spacer()
        }
    }
}

struct ScheduleRow_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleRow(alarm: Alarm(uuid: "",
                                 time: Time(hour: 10, min: 30),
                                 playlistLabel: "A Bit of Lunch",
                                 repeatStatus: [
                                    .Tuesday,
                                    .Wednesday,
                                        .Thusday,
                                        .Friday,
                                        .Saturday,
                                    . Sunday]))
    }
}
