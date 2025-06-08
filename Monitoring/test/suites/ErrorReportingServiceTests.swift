//
//  ErrorReportingServiceTests.swift
//  YMMonitoringTests
//
//  Created by Yakov Manshin on 5/24/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMMonitoring

import Foundation
import Testing

struct ErrorReportingServiceTests {
    
    private let service: ErrorReportingService
    private let proxy = ErrorReportingServiceProxyStub()
    
    init() {
        let configuration = ErrorReportingServiceConfiguration(proxy: proxy)
        service = ErrorReportingService(configuration: configuration)
    }
    
    @Test func start_success() async throws {
        try await service.start()
        
        #expect(await service.isReporting)
    }
    
    @Test func start_proxySetupError() async throws {
        let proxyError = NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "TEST_ProxyError"])
        proxy.setUp_result = .failure(proxyError)
        
        let thrownError = try await #require(throws: ErrorReportingService.Error.self) {
            try await service.start()
        }
        
        #expect(await !service.isReporting)
        guard case .proxySetupFailed(let underlyingError) = thrownError else {
            Issue.record(thrownError, "Unexpected error thrown")
            return
        }
        #expect(underlyingError as NSError == proxyError)
        #expect(proxy.setUp_invocationCount == 1)
        #expect(proxy.reportError_invocationCount == 0)
    }
    
    @Test func start_queueProcessing() async throws {
        let errorToReport = NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "TEST_ErrorDesc"])
        try await service.reportError(errorToReport)
        
        await #expect(service.errorQueue.count == 1)
        
        try await service.start()
        
        #expect(await service.isReporting)
        await #expect(service.errorQueue.isEmpty)
        #expect(proxy.setUp_invocationCount == 1)
        #expect(proxy.reportError_invocationCount == 1)
        try #require(proxy.reportError_errors.count == 1)
        #expect(proxy.reportError_errors[0] as NSError == errorToReport)
    }
    
    @Test func start_queueProcessing_error() async throws {
        let errorToReport = NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "TEST_ErrorDesc"])
        try await service.reportError(errorToReport)
        let proxyError = NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "TEST_ProxyError"])
        proxy.reportError_result = .failure(proxyError)
        
        let thrownError = try await #require(throws: ErrorReportingService.Error.self) {
            try await service.start()
        }
        
        // Even though some errors weren't processed, error reporting is still running.
        #expect(await service.isReporting)
        guard case .queueProcessingFailed(let underlyingErrors) = thrownError else {
            Issue.record(thrownError, "Unexpected error thrown")
            return
        }
        try #require(underlyingErrors.count == 1)
        #expect(underlyingErrors[0].queuedError as NSError == errorToReport)
        let processingError = try #require(underlyingErrors[0].processingError as? ErrorReportingService.Error)
        guard case .errorProcessingFailed(let underlyingProcessingError) = processingError else {
            Issue.record(processingError, "Unexpected error thrown")
            return
        }
        #expect(underlyingProcessingError as NSError == proxyError)
        #expect(proxy.setUp_invocationCount == 1)
        #expect(proxy.reportError_invocationCount == 1)
        #expect(proxy.reportError_errors.count == 1)
    }
    
    @Test func reportError_whenReporting() async throws {
        try await service.start()
        let errorToReport = NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "TEST_ErrorDesc"])
        
        try await service.reportError(errorToReport)
        
        #expect(await service.isReporting)
        await #expect(service.errorQueue.isEmpty)
        try #require(proxy.reportError_invocationCount == 1)
        #expect(proxy.reportError_errors[0] as NSError == errorToReport)
    }
    
    @Test func reportError_whenNotReporting() async throws {
        let errorToReport = NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "TEST_ErrorDesc"])
        
        try await service.reportError(errorToReport)
        
        #expect(await !service.isReporting)
        try await #require(service.errorQueue.count == 1)
        await #expect(service.errorQueue[0] as NSError == errorToReport)
        #expect(proxy.reportError_invocationCount == 0)
    }
    
    @Test func reportError_withQueuedErrors() async throws {
        let errorToReport1 = NSError(domain: "TEST_Error", code: 123)
        let errorToReport2 = NSError(domain: "TEST_Error", code: 456)
        let errorToReport3 = NSError(domain: "TEST_Error", code: 789)
        
        try await service.reportError(errorToReport1)
        try await service.reportError(errorToReport2)
        try await service.start()
        try await service.reportError(errorToReport3)
        
        #expect(await service.isReporting)
        await #expect(service.errorQueue.isEmpty)
        #expect(proxy.setUp_invocationCount == 1)
        #expect(proxy.reportError_invocationCount == 3)
        try #require(proxy.reportError_errors.count == 3)
        #expect(proxy.reportError_errors[0] as NSError == errorToReport1)
        #expect(proxy.reportError_errors[1] as NSError == errorToReport2)
        #expect(proxy.reportError_errors[2] as NSError == errorToReport3)
    }
    
    @Test func reportError_processingError() async throws {
        try await service.start()
        let proxyError = NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "TEST_ProxyError"])
        proxy.reportError_result = .failure(proxyError)
        let errorToReport = NSError(domain: "TEST_Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "TEST_ErrorDesc"])
        
        let thrownError = try await #require(throws: ErrorReportingService.Error.self) {
            try await service.reportError(errorToReport)
        }
        
        #expect(await service.isReporting)
        guard case .errorProcessingFailed(let underlyingError) = thrownError else {
            Issue.record(thrownError, "Unexpected error thrown")
            return
        }
        #expect(underlyingError as NSError == proxyError)
        #expect(proxy.setUp_invocationCount == 1)
        #expect(proxy.reportError_invocationCount == 1)
        try #require(proxy.reportError_errors.count == 1)
        #expect(proxy.reportError_errors[0] as NSError == errorToReport)
    }
    
}
