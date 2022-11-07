//
//  FilterButtonView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 26/10/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI
import PumpyLibrary

extension ScheduleView {
    
    struct FilterDaysView: View {
        
        @Binding var days: DetailInfo.DaysOfWeek?
        
        var body: some View {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    if #available(iOS 15, *) {
                        Menu(content: {
                            Picker(selection: $days, label: ImageButtonView()) {
                                content
                            }
                        }, label: {
                            ImageButtonView()
                        })
                    } else {
                        Picker(selection: $days, label: ImageButtonView()) {
                           content
                        }
                        .pickerStyle(MenuPickerStyle())
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        
        @ViewBuilder
        var content: some View {
            Text("Every day").tag(nil as DetailInfo.DaysOfWeek?)
            ForEach(DetailInfo.DaysOfWeek.allCases, id: \.self) { day in
                Text(day.rawValue).tag(day as DetailInfo.DaysOfWeek?)
            }
        }
        
    }
    
}

#if DEBUG
struct FilterButtonView_Previews: PreviewProvider {
    
    struct TestUser: ScheduledUser {
        var username: String = "Test"
        var alarmData = AlarmData(username: "Test")
    }
    
    static var previews: some View {
        return NavigationView {
            ScheduleView(user: TestUser(), getPlists: {return []})
        }.accentColor(.pumpyPink)
    }
}
#endif

extension ScheduleView.FilterDaysView {
    struct ImageButtonView: View {
        var body: some View {
            Image(systemName: "calendar")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .background(Color.pumpyPink)
                .clipShape(Circle())
                .shadow(color: .black, radius:10)
                .padding()
        }
    }
}
