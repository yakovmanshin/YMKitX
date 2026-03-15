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
    
    @Test(arguments: [nil, "TEST_Custom Category"]) func log(customCategoryName: String?) async {
        let message = "TEST_Log Message"
        if let customCategoryName {
            await service.log(forCategory: customCategoryName, message)
        } else {
            await service.log(message)
        }
        
        #expect(loggingService.log_invocationCount == 1)
        #expect(loggingService.log_levels == [.default])
        #expect(loggingService.log_messages == [message])
        if let customCategoryName {
            #expect(loggingService.log_categories == [.custom(customCategoryName)])
        } else {
            #expect(loggingService.log_categories == [.default])
        }
    }
    
    @Test(arguments: [nil, "TEST_Custom Category"]) func logSync(customCategoryName: String?) async throws {
        let message = "TEST_Log Message"
        if let customCategoryName {
            service.logSync(forCategory: customCategoryName, message)
        } else {
            service.logSync(message)
        }
        
        try await Task.sleep(for: .milliseconds(10))
        
        #expect(loggingService.log_invocationCount == 1)
        #expect(loggingService.log_levels == [.default])
        #expect(loggingService.log_messages == [message])
        if let customCategoryName {
            #expect(loggingService.log_categories == [.custom(customCategoryName)])
        } else {
            #expect(loggingService.log_categories == [.default])
        }
    }
    
}
