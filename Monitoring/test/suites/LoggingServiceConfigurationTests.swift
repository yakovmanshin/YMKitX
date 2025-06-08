//
//  LoggingServiceConfigurationTests.swift
//  YMMonitoringTests
//
//  Created by Yakov Manshin on 9/13/24.
//  Copyright © 2024 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMMonitoring

import Testing

struct LoggingServiceConfigurationTests {
    
    @Test func init_noWhitespaces() {
        let configuration = LoggingServiceConfiguration(
            subsystem: "TEST_SomeSubsystem",
            defaultCategory: "TEST_SomeCategory"
        )
        
        #expect(configuration.subsystem == "TEST_SomeSubsystem")
        #expect(configuration.defaultCategory == "TEST_SomeCategory")
    }
    
    @Test func init_withWhitespaces() {
        let configuration = LoggingServiceConfiguration(
            subsystem: "TEST Another Subsystem",
            defaultCategory: "TEST Another Category"
        )
        
        #expect(configuration.subsystem == "TEST-Another-Subsystem")
        #expect(configuration.defaultCategory == "TEST-Another-Category")
    }
    
    @Test func init_withNewlines() {
        let configuration = LoggingServiceConfiguration(
            subsystem: "TEST\nAnother\nSubsystem",
            defaultCategory: "TEST\nAnother\nCategory"
        )
        
        #expect(configuration.subsystem == "TEST-Another-Subsystem")
        #expect(configuration.defaultCategory == "TEST-Another-Category")
    }
    
}
