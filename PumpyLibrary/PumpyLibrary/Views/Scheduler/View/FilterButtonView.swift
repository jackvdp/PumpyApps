//
//  FilterButtonView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 26/10/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct FilterDaysView: View {
    
    @Binding var days: DetailInfo.DaysOfWeek?
    
    var body: some View {
        Menu(content: {
            Picker(selection: $days, label: ImageButtonView()) {
                content
            }
        }, label: {
            ImageButtonView()
        })
    }
    
    @ViewBuilder
    var content: some View {
        ForEach(DetailInfo.DaysOfWeek.allCases.reversed(), id: \.self) { day in
            Text(day.rawValue).tag(day as DetailInfo.DaysOfWeek?)
        }
        Text("Every day").tag(nil as DetailInfo.DaysOfWeek?)
    }
    
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

#if DEBUG
struct FilterButtonView_Previews: PreviewProvider {
    
    static var previews: some View {
        FilterDaysView(days: .constant(nil))
    }
}
#endif
