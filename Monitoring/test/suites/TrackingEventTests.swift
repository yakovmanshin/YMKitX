//
//  TrackingEventTests.swift
//  YMMonitoringTests
//
//  Created by Yakov Manshin on 9/5/24.
//  Copyright © 2024 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMMonitoring

import XCTest

final class TrackingEventTests: XCTestCase {
    
    func test_init_noParameters() {
        let event = TrackingEvent("TEST_Event")
        
        XCTAssertEqual(event.name, "TEST_Event")
        XCTAssertTrue(event.parameters.isEmpty)
    }
    
    func test_init_withParameters() {
        let event = TrackingEvent("TEST_Event", parameters: ["TEST_Key1": "TEST_Value1", "TEST_Key2": 123])
        
        XCTAssertEqual(event.name, "TEST_Event")
        XCTAssertEqual(event.parameters.count, 2)
        XCTAssertEqual(event.parameters["TEST_Key1"] as? String, "TEST_Value1")
        XCTAssertEqual(event.parameters["TEST_Key2"] as? Int, 123)
    }
    
}
