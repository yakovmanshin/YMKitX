//
//  LoggingServiceTests.swift
//  YMMonitoringTests
//
//  Created by Yakov Manshin on 9/13/24.
//  Copyright © 2024 Yakov Manshin. See the LICENSE file for license info.
//

#if !os(Linux)

@testable import YMMonitoring

import OSLog
import XCTest

@available(iOS 15, *)
final class LoggingServiceTests: XCTestCase {
    
    private var service: LoggingService!
    private let store = try! OSLogStore(scope: .currentProcessIdentifier)
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        service = LoggingService(configuration: .init(subsystem: "TEST_Subsystem", defaultCategory: "TEST_Category"))
    }
    
    func test_logWithMessage_defaultCategory_debugLevel() async throws {
        await service.log(for: .default, level: .debug, "TEST_LogMessage")
        
        let entries = try store.getEntries()
        XCTAssertTrue(entries.contains(where: { $0.composedMessage == "TEST_LogMessage" }))
    }
    
    func test_logError() async throws {
        await service.logError(
            NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "TEST_ErrorDescription"]),
            for: .default
        )
        
        let entries = try store.getEntries()
        XCTAssertTrue(entries.contains(where: { $0.composedMessage == "Error: TEST_ErrorDescription" }))
    }
    
}

#endif
