//
//  MonitoringServiceConfiguration.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 5/25/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

/// The object used to configure the monitoring service.
public struct MonitoringServiceConfiguration: Sendable {
    
    /// Determines whether reported errors should also be logged.
    let logErrors: Bool
    
    /// Determines whether tracked events should also be logged.
    let logEvents: Bool
    
    /// Determines whether reported errors should also be tracked.
    let trackErrors: Bool
    
    /// Defines the name used to track reported errors.
    ///
    /// + This property isn’t used if `trackErrors` is `false`.
    let eventNameForErrors: String
    
    public init(
        logErrors: Bool = true,
        logEvents: Bool = false,
        trackErrors: Bool = true,
        eventNameForErrors: String = "YMMonitoringError"
    ) {
        self.logErrors = logErrors
        self.logEvents = logEvents
        self.trackErrors = trackErrors
        self.eventNameForErrors = eventNameForErrors
    }
    
}
