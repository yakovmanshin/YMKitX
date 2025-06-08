//
//  TrackingServiceProxyStub.swift
//  YMMonitoringTests
//
//  Created by Yakov Manshin on 7/20/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

import YMMonitoring

final class TrackingServiceProxyStub {
    
    nonisolated(unsafe) var setUp_invocationCount = 0
    nonisolated(unsafe) var setUp_configurations = [TrackingServiceConfiguration]()
    nonisolated(unsafe) var setUp_result: Result<Void, any Error>!
    
    nonisolated(unsafe) var trackEvent_invocationCount = 0
    nonisolated(unsafe) var trackEvent_events = [TrackingEvent]()
    nonisolated(unsafe) var trackEvent_result: Result<Void, any Error>!
    
}

extension TrackingServiceProxyStub: TrackingServiceConfiguration.Proxy {
    
    func setUp(with configuration: TrackingServiceConfiguration) async throws {
        setUp_invocationCount += 1
        setUp_configurations.append(configuration)
        if case .failure(let error) = setUp_result {
            throw error
        }
    }
    
    func trackEvent(_ event: TrackingEvent) async throws {
        trackEvent_invocationCount += 1
        trackEvent_events.append(event)
        if case .failure(let error) = trackEvent_result {
            throw error
        }
    }
    
}
