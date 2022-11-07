//
//  SelectDaysView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 18/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct SelectDaysView: View {
    
    @Binding var selectedDays: [DetailInfo.DaysOfWeek]
    
    var body: some View {
        List(DetailInfo.DaysOfWeek.allCases, id: \.self) {
            SelectDaysRowView(day: $0, selectedDays: $selectedDays)
        }
        .navigationTitle("Days")
    }
}

struct SelectDaysView_Previews: PreviewProvider {
    
    @State static var selectedDays: [DetailInfo.DaysOfWeek] = [.Thusday]
    
    static var previews: some View {
        SelectDaysView(selectedDays: $selectedDays)
    }
}

struct SelectDaysRowView: View {
    
    let day: DetailInfo.DaysOfWeek
    @Binding var selectedDays: [DetailInfo.DaysOfWeek]
    
    var body: some View {
        Button(action: {
            if selectedDays.contains(day) {
                selectedDays.removeAll(where: { $0 == day })
            } else {
                selectedDays.append(day)
                selectedDays.sort(by: { $0.index < $1.index })
            }
        }) {
            HStack {
                Text(day.rawValue)
                Spacer()
                if selectedDays.contains(day) {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
