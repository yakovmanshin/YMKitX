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
    /// - Parameter message: *Required.* The message to log.
    func log(for category: LogCategory, _ message: String) async
    
    /// Logs the error.
    ///
    /// - Parameter error: *Required.* The error to log.
    func logError(_ error: any Error, for category: LogCategory) async
    
    /// Logs an error with the specified message.
    ///
    /// - Parameter message: *Required.* The message which describes the error.
    func logError(for category: LogCategory, _ message: String) async
    
}

// MARK: - Log Category

enum LogCategory: Hashable {
    case `default`
    case custom(String)
}
