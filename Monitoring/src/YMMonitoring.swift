//
//  YMMonitoring.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 5/3/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

/// Initializes and configures the monitoring service.
///
/// - Parameters:
///   - components: *Required.* The components you want to enable, with their corresponding configurations.
///   If you specify the same component multiple times, the last configuration instance will be used.
///   - configuration: *Required.* The monitoring service’s configuration.
///
/// - Returns: A new opaque-type instance of the monitoring service.
public func makeMonitoringService(
    components: [MonitoringComponentConfiguration],
    configuration: MonitoringServiceConfiguration,
) -> some MonitoringServiceProtocol {
    var errorReportingService: ErrorReportingService?
    var loggingService: LoggingService?
    var trackingService: TrackingService?
    
    components.forEach { component in
        switch component {
        case .errorReporting(let configuration):
            errorReportingService = ErrorReportingService(configuration: configuration)
        case .logging(let configuration):
            loggingService = LoggingService(configuration: configuration)
        case .tracking(let configuration):
            trackingService = TrackingService(configuration: configuration)
        }
    }
    
    return MonitoringService(
        configuration: configuration,
        errorReportingService: errorReportingService,
        loggingService: loggingService,
        trackingService: trackingService
    )
}
