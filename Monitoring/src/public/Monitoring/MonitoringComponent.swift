//
//  MonitoringComponent.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 5/25/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

/// The component of the monitoring system.
public enum MonitoringComponent: Sendable {
    case errorReporting
    case logging
    case tracking
}

/// The configuration for each of the monitoring system’s components.
public enum MonitoringComponentConfiguration: Sendable {
    case errorReporting(ErrorReportingServiceConfiguration)
    case logging(LoggingServiceConfiguration)
    case tracking(TrackingServiceConfiguration)
}
