//
//  LoggingServiceProtocol.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 12/20/20.
//  Copyright © 2020 Yakov Manshin. See the LICENSE file for license info.
//

// MARK: - Logging Service

/// The object that logs events during the app’s lifecycle.
protocol LoggingServiceProtocol: Sendable {
    
    /// Logs the specified message.
    /// 
    /// - Parameter category: *Required.* The log category to write the message to.
    /// - Parameter level: *Required.* The log level to use.
    /// - Parameter message: *Required.* The message to log.
    func log(for category: LogCategory, level: LogLevel, _ message: String) async
    
    /// Logs the error.
    ///
    /// - Parameter error: *Required.* The error to log.
    func logError(_ error: any Error, for category: LogCategory) async
    
}

// MARK: - Log Category

enum LogCategory: Hashable {
    case `default`
    case custom(String)
}
