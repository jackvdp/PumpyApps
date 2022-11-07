//
//  DetailInfo.swift
//  AlarmClone
//
//  Created by Jes Yang on 2019/10/24.
//  Copyright © 2019 Jes Yang. All rights reserved.
//

import Foundation

public enum DetailInfo {
    
    static let repeatArray: [String] = DaysOfWeek.allCases.map { $0.rawValue }

    public enum DaysOfWeek: String, CaseIterable, Equatable {
        case Sunday, Monday, Tuesday, Wednesday, Thusday, Friday, Saturday
        var index: Int { DaysOfWeek.allCases.firstIndex(of: self)! }
    }
    
    enum repeatAdditional {
        case Never, Everday, Weekend, Weekday
        
        var description: String {
            switch self {
            case .Never: return "Every day"
            case .Everday: return "Every day"
            case .Weekend: return "Weekend"
            case .Weekday: return "Weekday"
            }
        }
    }
    
    public static func getCurrentDayFormatted() -> DetailInfo.DaysOfWeek {
        
        let dayString = Calendar.current.component(.weekday, from: Date())
        
        switch dayString {
        case 1:
            return .Sunday
        case 2:
            return .Monday
        case 3:
            return .Tuesday
        case 4:
            return .Wednesday
        case 5:
            return .Thusday
        case 6:
            return .Friday
        case 7:
            return .Saturday
        default:
            return .Friday
        }
    }
}

extension Array where Element == DetailInfo.DaysOfWeek {

    var uiString: String {
        switch self {
        case []:
            return DetailInfo.repeatAdditional.Never.description
        case [.Sunday, .Monday, .Tuesday, .Wednesday, .Thusday, .Friday, .Saturday]:
            return DetailInfo.repeatAdditional.Everday.description
        case [.Sunday, .Saturday]:
            return "\(DetailInfo.repeatAdditional.Weekend.description)s"
        case [.Monday, .Tuesday, .Wednesday, .Thusday, .Friday]:
            return "\(DetailInfo.repeatAdditional.Weekday.description)s"
        default:
            return map{ $0.rawValue.prefix(3) }.joined(separator: " ")
        }
    }
    
    var uiStringMain: String {
        switch self {
        case []:
            return ", every day"
        case [.Sunday, .Monday, .Tuesday, .Wednesday, .Thusday, .Friday, .Saturday]:
            return ", \(DetailInfo.repeatAdditional.Everday.description.lowercased())"
        case [.Sunday, .Saturday]:
            return ", every \(DetailInfo.repeatAdditional.Weekend.description.lowercased())"
        case [.Monday, .Tuesday, .Wednesday, .Thusday, .Friday]:
            return ", every \(DetailInfo.repeatAdditional.Weekday.description.lowercased())"
        default:
            return ", \(uiString)"
        }
    }
    
}
