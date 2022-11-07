//
//  TrackFeaturesToView.swift
//  Pumpy Playlist Manager
//
//  Created by Jack Vanderpump on 16/06/2022.
//

import Foundation
import SwiftUI

class ColumnsShowing: ObservableObject {
    @Published var columns = [ColumnTable(showing: true, name: "BPM"),
                   ColumnTable(showing: true, name: "Peak"),
                   ColumnTable(showing: true, name: "Dance"),
                   ColumnTable(showing: true, name: "Energy"),
                   ColumnTable(showing: true, name: "Happiness"),
                   ColumnTable(showing: true, name: "Loud"),
                   ColumnTable(showing: true, name: "Instrumental"),
                   ColumnTable(showing: true, name: "Acoustic"),
                   ColumnTable(showing: true, name: "Live"),
                   ColumnTable(showing: true, name: "Popularity"),
                   ColumnTable(showing: true, name: "Genre"),
                   ColumnTable(showing: true, name: "Year")]
    
    func columnWidth(_ displayWidth: CGFloat) -> CGFloat {
        let noOfColumns = columns.filter({$0.showing}).count + 1
        var constants = CGFloat((noOfColumns * 10) + 150)
        columns[10].showing ? constants += 35 : nil
        return (displayWidth - constants) / CGFloat(noOfColumns)
    }

    struct ColumnTable: Hashable {
        var showing: Bool
        var name: String
    }
}


