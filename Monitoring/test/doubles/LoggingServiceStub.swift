//
//  LoggingServiceStub.swift
//  YMMonitoringTests
//
//  Created by Yakov Manshin on 3/15/26.
//  Copyright © 2026 Yakov Manshin. See the LICENSE file for license info.
//

@testable import YMMonitoring

final class LoggingServiceStub {
    
    nonisolated(unsafe) var log_invocationCount = 0
    nonisolated(unsafe) var log_categories = [LogCategory]()
    nonisolated(unsafe) var log_levels = [LogLevel]()
    nonisolated(unsafe) var log_messages = [String]()
    
    nonisolated(unsafe) var logError_invocationCount = 0
    nonisolated(unsafe) var logError_errors = [any Error]()
    nonisolated(unsafe) var logError_categories = [LogCategory]()
    
}

extension LoggingServiceStub: LoggingServiceProtocol {
    
    func log(for category: LogCategory, level: LogLevel, _ message: String) async {
        log_invocationCount += 1
        log_categories.append(category)
        log_levels.append(level)
        log_messages.append(message)
    }
    
    func logError(_ error: any Error, for category: LogCategory) async {
        logError_invocationCount += 1
        logError_errors.append(error)
        logError_categories.append(category)
    }
    
}
