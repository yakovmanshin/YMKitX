//
//  ErrorReportingServiceProxyStub.swift
//  YMMonitoringTests
//
//  Created by Yakov Manshin on 5/24/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

import YMMonitoring

final class ErrorReportingServiceProxyStub {
    
    nonisolated(unsafe) var setUp_invocationCount = 0
    nonisolated(unsafe) var setUp_configurations = [ErrorReportingServiceConfiguration]()
    nonisolated(unsafe) var setUp_result: Result<Void, any Error>!
    
    nonisolated(unsafe) var reportError_invocationCount = 0
    nonisolated(unsafe) var reportError_errors = [any Error]()
    nonisolated(unsafe) var reportError_result: Result<Void, any Error>!
    
}

extension ErrorReportingServiceProxyStub: ErrorReportingServiceConfiguration.Proxy {
    
    func setUp(with configuration: ErrorReportingServiceConfiguration) async throws {
        setUp_invocationCount += 1
        setUp_configurations.append(configuration)
        if case .failure(let error) = setUp_result {
            throw error
        }
    }
    
    func reportError(_ error: any Error) async throws {
        reportError_invocationCount += 1
        reportError_errors.append(error)
        if case .failure(let error) = reportError_result {
            throw error
        }
    }
    
}
