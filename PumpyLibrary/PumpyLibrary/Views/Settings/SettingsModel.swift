//
//  File.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 07/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import SwiftUI

public struct SettingsModel: Encodable {
    public var showMusicLibrary: Bool = true
    public var showMusicStore: Bool = true
    public var showMusicLab: Bool = true
    public var showScheduler: Bool = true
    public var showDownloader: Bool = true
    public var showRepeater: Bool = true
    public var showBlocked: Bool = true
    public var showExternalDisplay: Bool = true
    public var banExplicit: Bool = false
    public var overrideSchedule: Bool = false
}

public struct SettingsDTOModel: Codable {
    public var showMusicLibrary: Bool?
    public var showMusicStore: Bool?
    public var showMusicLab: Bool?
    public var showScheduler: Bool?
    public var showDownloader: Bool?
    public var showRepeater: Bool?
    public var showBlocked: Bool?
    public var showExternalDisplay: Bool?
    public var banExplicit: Bool?
    public var overrideSchedule: Bool?
    
    func toDomain() -> SettingsModel {
        SettingsModel(
            showMusicLibrary: self.showMusicLibrary ?? true,
            showMusicStore: self.showMusicStore ?? true,
            showMusicLab: self.showMusicLab ?? true,
            showScheduler: self.showScheduler ?? true,
            showDownloader: self.showDownloader ?? true,
            showRepeater: self.showRepeater ?? true,
            showBlocked: self.showBlocked ?? true,
            showExternalDisplay: self.showExternalDisplay ?? true,
            banExplicit: self.banExplicit ?? false,
            overrideSchedule: self.overrideSchedule ?? false
        )
    }
}
