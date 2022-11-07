//
//  File.swift
//  Pumpy Music iOS
//
//  Created by Jack Vanderpump on 07/03/2021.
//  Copyright © 2021 Jack Vanderpump. All rights reserved.
//

import Foundation
import SwiftUI

public struct SettingsModel: Codable {
    public var showMusicLibrary: Bool = true
    public var showMusicStore: Bool = true
    public var showScheduler: Bool = true
    public var showDownloader: Bool = true
    public var showRepeater: Bool = true
    public var showBlocked: Bool = true
    public var crossfadeOn: Bool = true
    public var showExternalDisplay: Bool = true
    public var banExplicit: Bool = false
    public var overrideSchedule: Bool = false
}
