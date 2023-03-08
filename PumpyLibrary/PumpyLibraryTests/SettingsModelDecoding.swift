//
//  SettingsModelDecoding.swift
//  PumpyLibraryTests
//
//  Created by Jack Vanderpump on 08/03/2023.
//

import XCTest
@testable import PumpyLibrary

final class SettingsModelDecoding: XCTestCase {

    func testDdecodingSettingsModel() throws {
        let data = Data("""
{
    "showMusicLibrary": false
}
""".utf8)
        var model: SettingsDTOModel?
        let decoder = JSONDecoder()
        do {
            model = try decoder.decode(SettingsDTOModel.self, from: data)
        } catch {
            print(error)
        }
        let domainModel = model?.toDomain()
        
        XCTAssertEqual(domainModel?.showMusicLibrary, false)
        XCTAssertEqual(domainModel?.showMusicLab, true)
    }


}

