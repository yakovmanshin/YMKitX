//
//  MonitoringServiceProtocol.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 5/18/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

/// The root object used for monitoring tasks.
public protocol MonitoringServiceProtocol: Sendable {
    
    /// Starts the monitoring service by configuring all its subsystems.
    func start() async throws(MonitoringServiceError)
    
    /// Schedules the event to be sent to the analytics subsystem.
    ///
    /// + This method may return before the event is fully processed.
    ///
    /// - Parameter event: *Required.* The monitoring event.
    func track(_ event: TrackingEvent) async
    
    /// Records the message in the local log.
    ///  
    /// - Parameters:
    ///   - category: *Required.* The log category.
    ///   - message: *Required.* The message to log.
    func log(forCategory category: String, _ message: String) async
    
    /// Records the message in the local log.
    ///
    /// - Parameters:
    ///   - message: *Required.* The message to log.
    func log(_ message: String) async
    
    /// Records information about the error.
    ///
    /// + This method may return before the error is fully processed.
    ///
    /// - Parameter error: *Required.* The error object.
    func reportError(_ error: any Error) async
    
    /// Records information about an error with the specified message.
    ///
    /// + This method may return before the message is fully processed.
    ///
    /// - Parameter message: *Required.* The error message.
    func reportError(_ message: String) async
    
}

// MARK: - Synchronous Versions

public extension MonitoringServiceProtocol {
    
    func trackSync(_ event: TrackingEvent) {
        Task(priority: .utility) {
            await track(event)
        }
    }
    
    func logSync(forCategory category: String, _ message: String) {
        Task(priority: .utility) {
            await log(forCategory: category, message)
        }
    }
    
    func logSync(_ message: String) {
        Task(priority: .utility) {
            await log(message)
        }
    }
    
    func reportErrorSync(_ error: any Error) {
        Task(priority: .utility) {
            await reportError(error)
        }
    }
    
    func reportErrorSync(_ message: String) {
        Task(priority: .utility) {
            await reportError(message)
        }
    }
    
}
