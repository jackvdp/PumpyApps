//
//  ShowColumnView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 17/06/2022.
//

import SwiftUI

struct ShowColumnView: View {
    
    @ObservedObject var showColumn: ColumnsShowing
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Columns")
                .font(.title3.weight(.bold))
            Divider()
            colCheckbox
        }
        .padding()
    }
    
    var colCheckbox: some View {
        ForEach(0..<showColumn.columns.count, id: \.self) { index in
            ColumnCheckbox(column: showColumn.columns[index], index: index, showColumns: showColumn)
        }
    }
    
    struct ColumnCheckbox: View {
        @State var column: ColumnsShowing.ColumnTable
        let index: Int
        @ObservedObject var showColumns: ColumnsShowing
        
        var body: some View {
            Toggle(column.name, isOn: $column.showing)
                .onChange(of: column.showing) { newValue in
                    showColumns.columns[index].showing = newValue
                }
        }
    }
}

 

struct ShowColumnView_Previews: PreviewProvider {
    static var previews: some View {
        ShowColumnView(showColumn: ColumnsShowing())
    }
}

