//
//  SoftwareVersionTests.swift
//  YMUtilitiesTests
//
//  Created by Yakov Manshin on 2/15/22.
//  Copyright © 2022 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMUtilities

import XCTest

final class SoftwareVersionTests: XCTestCase {
    
    private lazy var decoder = JSONDecoder()
    private lazy var encoder = JSONEncoder()
    
    func testVersionStringNoZeros() {
        let version = SoftwareVersion(major: 1, minor: 23, patch: 45)
        
        let versionString = version.string
        
        XCTAssertEqual(versionString, "1.23.45")
    }
    
    func testVersionStringWithZeros() {
        let version = SoftwareVersion(major: 0, minor: 1, patch: 0)
        
        let versionString = version.string
        
        XCTAssertEqual(versionString, "0.1.0")
    }
    
    func testSuccessfulInitializationFromDecoderAllComponents() {
        let versionStringData = #""1.23.45""#.data(using: .utf8)!
        
        let version = try? decoder.decode(SoftwareVersion.self, from: versionStringData)
        
        XCTAssertEqual(version?.major, 1)
        XCTAssertEqual(version?.minor, 23)
        XCTAssertEqual(version?.patch, 45)
    }
    
    func testSuccessfulInitializationFromDecoderMajorOnly() {
        let versionStringData = #""3""#.data(using: .utf8)!
        
        let version = try? decoder.decode(SoftwareVersion.self, from: versionStringData)
        
        XCTAssertEqual(version?.major, 3)
        XCTAssertEqual(version?.minor, 0)
        XCTAssertEqual(version?.patch, 0)
    }
    
    func testUnsuccessfulInitializationFromDecoderInvalidCharacters() {
        let versionStringData = #""1.INVALID-STRING.23.45""#.data(using: .utf8)!
        
        let version = try? decoder.decode(SoftwareVersion.self, from: versionStringData)
        
        XCTAssertNil(version)
    }
    
    func testUnsuccessfulInitializationFromDecoderTooManyComponents() {
        let versionStringData = #""1.23.45.67""#.data(using: .utf8)!
        
        let version = try? decoder.decode(SoftwareVersion.self, from: versionStringData)
        
        XCTAssertNil(version)
    }
    
    func testInitializationFromStringAllComponents() {
        let versionString = "1.23.45"
        
        let version = SoftwareVersion(versionString)
        
        XCTAssertEqual(version?.major, 1)
        XCTAssertEqual(version?.minor, 23)
        XCTAssertEqual(version?.patch, 45)
    }
    
    func testInitializationFromStringMajorAndMinor() {
        let versionString = "1.23"
        
        let version = SoftwareVersion(versionString)
        
        XCTAssertEqual(version?.major, 1)
        XCTAssertEqual(version?.minor, 23)
        XCTAssertEqual(version?.patch, 0)
    }
    
    func testInitializationFromStringMajorOnly() {
        let versionString = "4"
        
        let version = SoftwareVersion(versionString)
        
        XCTAssertEqual(version?.major, 4)
        XCTAssertEqual(version?.minor, 0)
        XCTAssertEqual(version?.patch, 0)
    }
    
    func testInitializationFromInvalidString() {
        let versionString = "1.INVALID-STRING.23.45"
        
        let version = SoftwareVersion(versionString)
        
        XCTAssertNil(version)
    }
    
    func testValidVersionStringValidation1() {
        let versionString = "1.23.45"
        
        XCTAssertNoThrow(try SoftwareVersion.validateVersionString(versionString))
    }
    
    func testValidVersionStringValidation2() {
        let versionString = "1"
        
        XCTAssertNoThrow(try SoftwareVersion.validateVersionString(versionString))
    }
    
    func testValidVersionStringValidation3() {
        let versionString = "0.0"
        
        XCTAssertNoThrow(try SoftwareVersion.validateVersionString(versionString))
    }
    
    func testInvalidVersionStringValidation() {
        let versionString = "1.INVALID-STRING.23.45"
        
        XCTAssertThrowsError(try SoftwareVersion.validateVersionString(versionString)) { error in
            guard case SoftwareVersion.InitializationError.versionStringDoesNotMatchRegEx = error else {
                return XCTFail("Unexpected error type")
            }
        }
    }
    
    func testOperatingSystemVersion() {
        let version = SoftwareVersion(major: 1, minor: 23, patch: 45)
        
        let osVersion = version.osVersion
        
        XCTAssertEqual(osVersion.majorVersion, 1)
        XCTAssertEqual(osVersion.minorVersion, 23)
        XCTAssertEqual(osVersion.patchVersion, 45)
    }
    
    func testCompareLessMajor() {
        let version1 = SoftwareVersion(major: 0, minor: 23, patch: 45)
        let version2 = SoftwareVersion(major: 1, minor: 2, patch: 3)
        
        XCTAssertLessThan(version1, version2)
    }
    
    func testCompareLessMinor() {
        let version1 = SoftwareVersion(major: 1, minor: 22, patch: 456)
        let version2 = SoftwareVersion(major: 1, minor: 23, patch: 45)
        
        XCTAssertLessThan(version1, version2)
    }
    
    func testCompareLessPatch() {
        let version1 = SoftwareVersion(major: 0, minor: 101, patch: 0)
        let version2 = SoftwareVersion(major: 0, minor: 101, patch: 1)
        
        XCTAssertLessThan(version1, version2)
    }
    
    func testCompareLessThanOrEqualMajor() {
        let version1 = SoftwareVersion(major: 0, minor: 23, patch: 45)
        let version2 = SoftwareVersion(major: 1, minor: 2, patch: 3)
        
        XCTAssertLessThanOrEqual(version1, version2)
    }
    
    func testCompareLessThanOrEqualMinor() {
        let version1 = SoftwareVersion(major: 1, minor: 22, patch: 456)
        let version2 = SoftwareVersion(major: 1, minor: 23, patch: 45)
        
        XCTAssertLessThanOrEqual(version1, version2)
    }
    
    func testCompareLessThanOrEqualPatch() {
        let version1 = SoftwareVersion(major: 0, minor: 101, patch: 0)
        let version2 = SoftwareVersion(major: 0, minor: 101, patch: 1)
        
        XCTAssertLessThanOrEqual(version1, version2)
    }
    
    func testCompareLessThanOrEqualEqual() {
        let version1 = SoftwareVersion(major: 123, minor: 456, patch: 789)
        let version2 = SoftwareVersion(major: 123, minor: 456, patch: 789)
        
        XCTAssertLessThanOrEqual(version1, version2)
    }
    
    func testCompareEqual() {
        let version1 = SoftwareVersion(major: 123, minor: 456, patch: 789)
        let version2 = SoftwareVersion(major: 123, minor: 456, patch: 789)
        
        XCTAssertEqual(version1, version2)
    }
    
    func testCompareGreaterThanOrEqualEqual() {
        let version1 = SoftwareVersion(major: 123, minor: 456, patch: 789)
        let version2 = SoftwareVersion(major: 123, minor: 456, patch: 789)
        
        XCTAssertGreaterThanOrEqual(version1, version2)
    }
    
    func testCompareGreaterThanOrEqualMajor() {
        let version1 = SoftwareVersion(major: 1, minor: 23, patch: 67)
        let version2 = SoftwareVersion(major: 0, minor: 45, patch: 89)
        
        XCTAssertGreaterThanOrEqual(version1, version2)
    }
    
    func testCompareGreaterThanOrEqualMinor() {
        let version1 = SoftwareVersion(major: 0, minor: 1, patch: 2)
        let version2 = SoftwareVersion(major: 0, minor: 0, patch: 3)
        
        XCTAssertGreaterThanOrEqual(version1, version2)
    }
    
    func testCompareGreaterThanOrEqualPatch() {
        let version1 = SoftwareVersion(major: 1, minor: 23, patch: 45)
        let version2 = SoftwareVersion(major: 1, minor: 23, patch: 4)
        
        XCTAssertGreaterThanOrEqual(version1, version2)
    }
    
    func testCompareGreaterMajor() {
        let version1 = SoftwareVersion(major: 1, minor: 23, patch: 67)
        let version2 = SoftwareVersion(major: 0, minor: 45, patch: 89)
        
        XCTAssertGreaterThan(version1, version2)
    }
    
    func testCompareGreaterMinor() {
        let version1 = SoftwareVersion(major: 0, minor: 1, patch: 2)
        let version2 = SoftwareVersion(major: 0, minor: 0, patch: 3)
        
        XCTAssertGreaterThan(version1, version2)
    }
    
    func testCompareGreaterPatch() {
        let version1 = SoftwareVersion(major: 1, minor: 23, patch: 45)
        let version2 = SoftwareVersion(major: 1, minor: 23, patch: 4)
        
        XCTAssertGreaterThan(version1, version2)
    }
    
    func test_encode() throws {
        let version = SoftwareVersion(major: 1, minor: 23, patch: 45)
        
        let versionData = try encoder.encode(version)
        let versionDataString = String(data: versionData, encoding: .utf8)!
        
        XCTAssertEqual(versionDataString, #""1.23.45""#)
    }
    
}
