//
//  ExtDisplaySettings.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 27/04/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import SwiftUI

struct ExtDisplaySettingsRows: View {
    @Binding var displayContent: ExtDisContentType
    @Binding var showQRCode: Bool
    @Binding var qrURL: String
    @Binding var marqueeTextLabel: String
    @Binding var marqueeSpeed: Double
    @Binding var qrType: QRType
    
    var body: some View {
        SelectContentType(contentType: $displayContent, selectionString: displayContent.rawValue)
        Toggle("Show QR Code", isOn: $showQRCode)
            .toggleStyle(SwitchToggleStyle(tint: Color.pumpyPink))
        if showQRCode {
            Picker("QR Type", selection: $qrType) {
                ForEach(QRType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            if qrType == .custom {
                NavigationLink(destination: URLTextField(urlString: $qrURL)) {
                    FormViewRow(title: "QR Link", subTitle: String())
                }
                NavigationLink(destination: QRMessageField(message: $marqueeTextLabel)) {
                    FormViewRow(title: "Message", subTitle: String())
                }
                MessageSpeed(marqueeSpeed: $marqueeSpeed)
            }
        }
    }
}

struct ExtDisplaySettings_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ExtDisplaySettingsRows(displayContent: .constant(.artworkAndTitles),
                                       showQRCode: .constant(true),
                                       qrURL: .constant("Test"),
                                       marqueeTextLabel: .constant("true"),
                                       marqueeSpeed: .constant(8.0),
                                       qrType: .constant(.playlist))
            }
            NavigationView {
                ExtDisplaySettingsRows.URLTextField(urlString: .constant("tes"))
            }
            NavigationView {
                ExtDisplaySettingsRows.QRMessageField(message: .constant("tes"))
            }
        }
    }
}

extension ExtDisplaySettingsRows {
    
    struct SelectContentType: View {
        
        @Binding var contentType: ExtDisContentType
        let allCases = ExtDisContentType.allCases
        let selectionString: String
        
        var body: some View {
            if #available(iOS 15, *) {
                HStack {
                    Text("Content:")
                    Spacer()
                    Picker("", selection: $contentType) {
                        ForEach(allCases, id: \.self) { i in
                            Text(i.rawValue)
                        }
                    }.pickerStyle(MenuPickerStyle())
                }
            } else {
                Picker(selection: $contentType, label:
                        FormViewRow(title: "Content:", subTitle: selectionString)
                ) {
                    ForEach(allCases, id: \.self) { i in
                        Text(i.rawValue)
                    }
                }.pickerStyle(MenuPickerStyle())
            }
        }
    }
    
    struct MessageSpeed: View {
        
        @Binding var marqueeSpeed: Double
        
        var body: some View {
            if #available(iOS 15, *) {
                
            } else {
                Picker(selection: $marqueeSpeed, label:
                        FormViewRow(title: "Message Speed:", subTitle: marqueeSpeed.description)
                ) {
                    ForEach(1...15, id: \.self) { i in
                        Text(String(i))
                    }
                }.pickerStyle(MenuPickerStyle())
            }
            
//            Picker("Message Speed", selection: $marqueeSpeed) {
//                ForEach(1...15, id: \.self) {
//                    Text(String($0))
//                }
//            }
        }
    }
    
    struct URLTextField: View {
        @Binding var urlString: String
        var body: some View {
            TextField("Enter link for QR Code:", text: $urlString)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .foregroundColor(.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.greyBGColour, Color.greyBGColour]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(10)
                .padding()
                .navigationBarTitle("QR Link:")
        }
    }
    
    struct QRMessageField: View {
        @Binding var message: String
        var body: some View {
            TextEditor(text: $message)
                .foregroundColor(.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.greyBGColour, Color.greyBGColour]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(10)
                .padding()
                .navigationBarTitle("QR Label")
        }
    }
    
    
}
