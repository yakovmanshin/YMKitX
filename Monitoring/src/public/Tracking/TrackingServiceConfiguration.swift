//
//  TrackingServiceConfiguration.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 7/20/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

// MARK: - Configuration

public struct TrackingServiceConfiguration: Sendable {
    
    let proxy: any Proxy
    let eventTransformer: @Sendable (TrackingEvent) -> TrackingEvent
    
    public init(
        proxy: any Proxy,
        eventTransformer: @escaping @Sendable (TrackingEvent) -> TrackingEvent = { $0 }
    ) {
        self.proxy = proxy
        self.eventTransformer = eventTransformer
    }
    
}

// MARK: - Proxy

extension TrackingServiceConfiguration {
    
    public protocol Proxy: Sendable {
        func setUp(with configuration: TrackingServiceConfiguration) async throws
        func trackEvent(_ event: TrackingEvent) async throws
    }
    
}
