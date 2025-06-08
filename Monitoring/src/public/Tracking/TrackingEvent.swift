//
//  TrackingEvent.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 1/2/21.
//  Copyright © 2021 Yakov Manshin. See the LICENSE file for license info.
//

// MARK: - Event

/// The object which describes a tracking event.
public struct TrackingEvent: Sendable {
    
    /// The name of the event.
    public let name: String
    
    /// The dictionary containing the event’s parameters.
    public let parameters: Parameters
    
    public init(_ name: String, parameters: Parameters = [:]) {
        self.name = name
        self.parameters = parameters
    }
    
}

// MARK: - Parameters

extension TrackingEvent {
    public typealias Parameters = [String: any Sendable]
}
