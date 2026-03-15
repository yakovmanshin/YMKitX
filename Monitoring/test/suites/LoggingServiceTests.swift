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
import Testing

struct LoggingServiceTests {
    
    private let service = LoggingService(configuration: .init(
        subsystem: "TEST_Subsystem",
        defaultCategory: "TEST_Category"
    ))
    private let store = try! OSLogStore(scope: .currentProcessIdentifier)
    
    @Test(arguments: [
        (.default, .default),
        (.custom("TEST_Custom Category 1"), .debug),
        (.custom("TEST_CustomCategory2"), .fault),
        (.custom("TEST_Cat3"), .error),
    ] as [(LogCategory, LogLevel)]) func log(category: LogCategory, level: LogLevel) async throws {
        let message = "TEST_Log Message"
        
        await service.log(for: category, level: level, message)
        
        let entries = try store.getEntries()
        #expect(entries.contains(where: { $0.composedMessage == message }))
    }
    
    @Test(arguments: [
        .default,
        .custom("TEST_Custom_Category_1")
    ] as [LogCategory]) func logError(category: LogCategory) async throws {
        let errorDescription = "TEST_ErrorDescription"
        
        await service.logError(
            NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: errorDescription]),
            for: .default
        )
        
        let entries = try store.getEntries()
        #expect(entries.contains(where: { $0.composedMessage == "Error: TEST_ErrorDescription" }))
    }
    
}

#endif
