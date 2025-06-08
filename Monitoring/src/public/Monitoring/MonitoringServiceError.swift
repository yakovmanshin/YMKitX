//
//  MonitoringServiceError.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 5/3/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

/// Errors thrown by the monitoring service.
public enum MonitoringServiceError: Error {
    case failedToStartComponents([(MonitoringComponent, any Error)])
}
