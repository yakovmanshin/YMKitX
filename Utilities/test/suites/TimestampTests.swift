//
//  TimestampTests.swift
//  YMUtilitiesTests
//
//  Created by Yakov Manshin on 11/21/21.
//  Copyright © 2021 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMUtilities

import XCTest

// MARK: - Tests

final class TimestampTests: XCTestCase {
    
    func testInitializationFromDate() {
        let date = Date(timeIntervalSince1970: Constants.numberOfSeconds)
        let timestamp = Timestamp(from: date)
        
        XCTAssertEqual(timestamp.timeInterval, date.timeIntervalSince1970)
    }
    
    func testInitializationFromIntegerLiteral() {
        let timestamp: Timestamp = 1510150673
        
        XCTAssertEqual(timestamp.timeInterval, TimeInterval(Constants.numberOfSeconds))
    }
    
    func testSecondsGetter() {
        let timestamp = Timestamp(Constants.numberOfSeconds)
        
        XCTAssertEqual(timestamp.seconds, Int(Constants.numberOfSeconds))
    }
    
    func testDateGetter() {
        let timestamp = Timestamp(Constants.numberOfSeconds)
        let date = Date(timeIntervalSince1970: Constants.numberOfSeconds)
        
        XCTAssertEqual(timestamp.date, date)
    }
    
    func testEquality() {
        let timestamp1 = Timestamp(Constants.numberOfSeconds)
        let timestamp2 = Timestamp(Constants.numberOfSeconds)
        
        XCTAssertEqual(timestamp1, timestamp2)
    }
    
    func testInequality() {
        let timestamp1 = Timestamp(Constants.lesserNumberOfSeconds)
        let timestamp2 = Timestamp(Constants.greaterNumberOfSeconds)
        
        XCTAssertNotEqual(timestamp1, timestamp2)
    }
    
    func testComparison() {
        let timestamp1 = Timestamp(Constants.lesserNumberOfSeconds)
        let timestamp2 = Timestamp(Constants.numberOfSeconds)
        let timestamp3 = Timestamp(Constants.greaterNumberOfSeconds)
        
        XCTAssertLessThan(timestamp1, timestamp2)
        XCTAssertGreaterThan(timestamp3, timestamp2)
        XCTAssertLessThanOrEqual(timestamp2, timestamp2)
        XCTAssertGreaterThanOrEqual(timestamp2, timestamp2)
    }
    
    func testDecoding() throws {
        guard
            let jsonData = Constants.jsonString.data(using: .utf8),
            let response = try? JSONDecoder().decode(TimestampResponse.self, from: jsonData)
        else { return XCTFail() }
        
        let timestamp = Timestamp(Constants.numberOfSeconds)
        
        XCTAssertEqual(response.timestamp, timestamp)
    }
    
    func testEncoding() {
        let response = TimestampResponse(timestamp: .init(Constants.numberOfSeconds))
        
        guard
            let jsonData = try? JSONEncoder().encode(response),
            let jsonString = String(data: jsonData, encoding: .utf8)
        else { return XCTFail() }
        
        XCTAssertEqual(jsonString, Constants.jsonString)
    }
    
}

// MARK: - TimestampResponse

fileprivate struct TimestampResponse: Codable {
    let timestamp: Timestamp
}

// MARK: - Constants

fileprivate enum Constants {
    static let jsonString = #"{"timestamp":1510150673}"#
    static let numberOfSeconds: TimeInterval = 1510150673
    static let lesserNumberOfSeconds: TimeInterval = 1510150672
    static let greaterNumberOfSeconds: TimeInterval = 1510150674
}
