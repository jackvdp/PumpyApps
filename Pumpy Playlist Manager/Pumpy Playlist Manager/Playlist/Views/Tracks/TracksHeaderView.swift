//
//  TracksheaderView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 15/06/2022.
//

import SwiftUI

struct TracksHeaderView: View {
    
    @ObservedObject var showingColumn: ColumnsShowing
    let widthOfTable: CGFloat
    let statsFont = Font.subheadline
    
    var body: some View {
        HStack(spacing: 10) {
            Text("Song Description")
                .font(statsFont)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(width: showingColumn.columnWidth(widthOfTable) + 150)
                .layoutPriority(1)
            Spacer(minLength: 10)
            ForEach(showingColumn.columns, id: \.self) { col in
                if col.showing && col.name == "Genre" {
                    Text(col.name)
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable) + 35)
                } else if col.showing {
                    Text(col.name)
                        .font(statsFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: showingColumn.columnWidth(widthOfTable))
                }
            }
        }
    }
}

struct TracksheaderView_Previews: PreviewProvider {
    static var previews: some View {
        TracksHeaderView(showingColumn: ColumnsShowing(), widthOfTable: 1000)
    }
}
