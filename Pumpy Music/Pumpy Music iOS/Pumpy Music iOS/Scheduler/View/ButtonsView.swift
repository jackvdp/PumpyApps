//
//  ButtonsView.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 18/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import SwiftUI

extension SetScheduleView {
    
    struct SaveButton: View {
        
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text("Save").fontWeight(.bold)
            }
        }
        
    }
    
    struct CancelButton: View {
        
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text("Cancel")
            }
        }
    }
    
    
}
