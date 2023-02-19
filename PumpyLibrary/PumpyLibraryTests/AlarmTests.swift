//
//  PumpyLibraryTests.swift
//  PumpyLibraryTests
//
//  Created by Jack Vanderpump on 29/10/2022.
//

import XCTest
import PumpyLibrary

final class AlarmTests: XCTestCase {
    
    let alarms: [Alarm] = [
        Alarm(uuid: "1", time: Time(hour: 13, min: 0), playlistLabel: "Pop", repeatStatus: [.Monday]),
        Alarm(uuid: "2", time: Time(hour: 11, min: 30), playlistLabel: "Rock", repeatStatus: []),
        Alarm(uuid: "3", time: Time(hour: 10, min: 30), playlistLabel: "Indie", repeatStatus: [.Wednesday]),
        Alarm(uuid: "4", time: Time(hour: 18, min: 15), playlistLabel: "R&B", repeatStatus: [.Saturday, .Sunday]),
        Alarm(uuid: "5", time: Time(hour: 18, min: 15), playlistLabel: "Soul", repeatStatus: [.Monday]),
        Alarm(uuid: "6", time: Time(hour: 1, min: 30), playlistLabel: "Funk", repeatStatus: [.Wednesday]),
        Alarm(uuid: "7", time: Time(hour: 10, min: 45), playlistLabel: "Rock", repeatStatus: [.Thusday]),
        Alarm(uuid: "8", time: Time(hour: 10, min: 30), playlistLabel: "Indie", repeatStatus: [.Thusday]),
    ]
    
    // MARK: - Next Alarm
    
    func testGetsNextAlarmSameHour() throws {
        var testDate: Date {
            Date.from(year: 2022, month: 10, day: 26, hour: 10, min: 0)! // Wednesday
        }
        let nextAlarm = alarms.getNextAlarm(date: testDate)
        let expectedAlarmUUID = "3"
        
        XCTAssertEqual(nextAlarm?.uuid, expectedAlarmUUID)
    }
    
    func testGetsNextAlarmSameHourButAfter() throws {
        var testDate: Date {
            Date.from(year: 2022, month: 10, day: 26, hour: 10, min: 40)! // Wednesday
        }
        let nextAlarm = alarms.getNextAlarm(date: testDate)
        let expectedAlarmUUID = "2"
        
        XCTAssertEqual(nextAlarm?.uuid, expectedAlarmUUID)
    }
    
    func testGetsNextAlarmIgnoreAlarmForDifferentDay() throws {
        var testDate: Date {
            Date.from(year: 2022, month: 10, day: 27, hour: 11, min: 0)! // Thursday
        }
        let nextAlarm = alarms.getNextAlarm(date: testDate)
        let expectedAlarmUUID = "2"
        
        XCTAssertEqual(nextAlarm?.uuid, expectedAlarmUUID)
    }
    
    func testGetsNextAlarmEarlyMorning() throws {
        var testDate: Date {
            Date.from(year: 2022, month: 10, day: 26, hour: 0, min: 0)! // Wednesday
        }
        let nextAlarm = alarms.getNextAlarm(date: testDate)
        let expectedAlarmUUID = "6"
        
        XCTAssertEqual(nextAlarm?.uuid, expectedAlarmUUID)
    }
    
    func testGetsNextAlarmOfSameHour() throws {
        var testDate: Date {
            Date.from(year: 2022, month: 10, day: 27, hour: 10, min: 35)! // Thursday
        }
        let mostRecentAlarm = alarms.getNextAlarm(date: testDate)
        let expectedAlarmUUID = "7"
        
        XCTAssertEqual(mostRecentAlarm?.uuid, expectedAlarmUUID)
    }
    
    // MARK: - Most Recent Alarm
    
    func testGetsMostRecentAlarmIgnoreEarlyMorning() throws {
        var testDate: Date {
            Date.from(year: 2022, month: 10, day: 26, hour: 11, min: 0)! // Wednesday
        }
        let mostRecentAlarm = alarms.getMostRecentAlarm(date: testDate)
        let expectedAlarmUUID = "3"
        
        XCTAssertEqual(mostRecentAlarm?.uuid, expectedAlarmUUID)
    }
    
    func testGetsMostRecentAlarmGetEarlyMorning() throws {
        var testDate: Date {
            Date.from(year: 2022, month: 10, day: 26, hour: 1, min: 0)! // Wednesday
        }
        let mostRecentAlarm = alarms.getMostRecentAlarm(date: testDate)
        let expectedAlarmUUID = "6"
        
        XCTAssertEqual(mostRecentAlarm?.uuid, expectedAlarmUUID)
    }
    
    func testGetsMostRecentAlarmButGetNextAlarm() throws {
        var testDate: Date {
            Date.from(year: 2022, month: 10, day: 26, hour: 10, min: 0)! // Wednesday 10am
        }
        let mostRecentAlarm = alarms.getMostRecentAlarm(date: testDate)
        let expectedAlarmUUID = "3"
        
        XCTAssertEqual(mostRecentAlarm?.uuid, expectedAlarmUUID)
    }
    
    func testGetsMostRecentAlarmOfSameHour() throws {
        var testDate: Date {
            Date.from(year: 2022, month: 10, day: 27, hour: 10, min: 35)! // Thursday
        }
        let mostRecentAlarm = alarms.getMostRecentAlarm(date: testDate)
        let expectedAlarmUUID = "8"
        
        XCTAssertEqual(mostRecentAlarm?.uuid, expectedAlarmUUID)
    }
    
    // MARK: - Get Date
    
    func testGetDateOfAlarm() throws {
        let dateOfAlarm = alarms.first.date()
        var expectedDate: Date {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            return Date.from(year: components.year!,
                             month: components.month!,
                             day: components.day!,
                             hour: 13,
                             min: 0)!
        }
        
        // Off by nanoseconds so use description
        XCTAssertEqual(dateOfAlarm?.description, expectedDate.description)
    }
    
    func testGetTomorrowDate() throws {
        var nilAlarm: Alarm?
        let dateOfAlarm = nilAlarm.date()
        var expectedDate: Date {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            return Date.from(year: components.year!,
                             month: components.month!,
                             day: components.day! + 1,
                             hour: 0,
                             min: 0)!
        }
        
        print(expectedDate)
        // Off by nanoseconds so use description
        XCTAssertEqual(dateOfAlarm?.description, expectedDate.description)
    }

}
