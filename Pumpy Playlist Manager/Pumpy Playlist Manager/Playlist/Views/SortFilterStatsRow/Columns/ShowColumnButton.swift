//
//  SHowColumnButton.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 17/06/2022.
//

import SwiftUI
import PumpyAnalytics

struct ShowColumnButton: View {
    @ObservedObject var showColumn: ColumnsShowing
    @State private var showColumnsFilter = false
    
    var body: some View {
        Button {
            showColumnsFilter.toggle()
        } label: {
            Image(systemName: "tablecells")
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(.pumpyPink)
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showColumnsFilter) {
            ShowColumnView(showColumn: showColumn)
        }
    }
    
}

struct ShowColumnButton_Previews: PreviewProvider {
    static var previews: some View {
        ShowColumnButton(showColumn: ColumnsShowing())
    }
}
