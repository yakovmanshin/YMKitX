//
//  LoggingServiceTests.swift
//  YMMonitoringTests
//
//  Created by Yakov Manshin on 9/13/24.
//  Copyright © 2024 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMMonitoring

import OSLog
import XCTest

@available(iOS 15, macOS 10.15, *)
final class LoggingServiceTests: XCTestCase {
    
    private var service: LoggingService!
    private let store = try! OSLogStore(scope: .currentProcessIdentifier)
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        service = LoggingService(configuration: .init(subsystem: "TEST_Subsystem", defaultCategory: "TEST_Category"))
    }
    
    func test_logWithMessage_defaultCategory() async throws {
        await service.log(for: .default, "TEST_LogMessage")
        
        let entries = try store.getEntries()
        XCTAssertTrue(entries.contains(where:  { $0.composedMessage == "TEST_LogMessage" }))
    }
    
    func test_logError() async throws {
        await service.logError(
            NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "TEST_ErrorDescription"]),
            for: .default
        )
        
        let entries = try store.getEntries()
        XCTAssertTrue(entries.contains(where:  { $0.composedMessage == "Error: TEST_ErrorDescription" }))
    }
    
    func test_logErrorWithMessage() async throws {
        await service.logError(for: .default, "TEST_ErrorMessage")
        
        let entries = try store.getEntries()
        XCTAssertTrue(entries.contains(where:  { $0.composedMessage == "Error: TEST_ErrorMessage" }))
    }
    
}
