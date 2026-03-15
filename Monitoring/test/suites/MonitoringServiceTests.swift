//
//  MonitoringServiceTests.swift
//  YMMonitoringTests
//
//  Created by Yakov Manshin on 3/14/26.
//  Copyright © 2026 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMMonitoring

import Testing

struct MonitoringServiceTests {
    
    let service: MonitoringService
    let configuration = MonitoringServiceConfiguration()
    let loggingService = LoggingServiceStub()
    
    init() {
        service = MonitoringService(
            configuration: configuration,
            errorReportingService: nil,
            loggingService: loggingService,
            trackingService: nil
        )
    }
    
    @Test(arguments: [
        (nil, .default),
        ("TEST_Custom Category 1", .info),
        ("TEST_CustomCategory2", .fault),
        ("TEST_Cat3", .debug),
    ] as [(String?, LogLevel)]) func log(category: String?, level: LogLevel) async {
        let message = "TEST_Log Message"
        
        await service.log(category: category, level: level, message)
        
        #expect(loggingService.log_invocationCount == 1)
        #expect(loggingService.log_levels == [level])
        #expect(loggingService.log_messages == [message])
        if let category {
            #expect(loggingService.log_categories == [.custom(category)])
        } else {
            #expect(loggingService.log_categories == [.default])
        }
    }
    
    @Test func log_defaultCategory() async {
        let message = "TEST_Log Message"
        
        await service.log(message)
        
        #expect(loggingService.log_invocationCount == 1)
        #expect(loggingService.log_categories == [.default])
        #expect(loggingService.log_levels == [.default])
        #expect(loggingService.log_messages == [message])
    }
    
    @Test func log_customCategory() async {
        let category = "TEST_CustomCategory"
        let message = "TEST_Log Message"
        
        await service.log(forCategory: category, message)
        
        #expect(loggingService.log_invocationCount == 1)
        #expect(loggingService.log_categories == [.custom(category)])
        #expect(loggingService.log_levels == [.default])
        #expect(loggingService.log_messages == [message])
    }
    
    @Test func logSync_customCategory() async throws {
        let category = "TEST_CustomCategory"
        let message = "TEST_Log Message"
        
        service.logSync(forCategory: category, message)
        
        try await Task.sleep(nanoseconds: 10 * 1_000_000)
        
        #expect(loggingService.log_invocationCount == 1)
        #expect(loggingService.log_categories == [.custom(category)])
        #expect(loggingService.log_levels == [.default])
        #expect(loggingService.log_messages == [message])
    }
    
}
