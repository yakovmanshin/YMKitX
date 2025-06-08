//
//  TrackingService.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 5/18/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

import Foundation

// MARK: - TrackingService

final actor TrackingService {
    
    // MARK: Properties
    
    private let configuration: TrackingServiceConfiguration
    
    private(set) var isTracking = false
    private(set) var eventQueue = [TrackingEvent]()
    
    // MARK: Initialization
    
    init(configuration: TrackingServiceConfiguration) {
        self.configuration = configuration
    }
    
}

// MARK: - TrackingServiceProtocol

extension TrackingService: TrackingServiceProtocol {
    
    func start() async throws(Error) {
        do {
            try await configuration.proxy.setUp(with: configuration)
        } catch {
            throw Error.proxySetupFailed(error)
        }
        
        defer { isTracking = true }
        try await processQueuedEvents()
    }
    
    private func processQueuedEvents() async throws(Error) {
        var processingErrors = [(TrackingEvent, Error)]()
        
        while !eventQueue.isEmpty {
            let dequeuedEvent = eventQueue.removeFirst()
            do {
                try await forceTrack(dequeuedEvent)
            } catch {
                processingErrors.append((dequeuedEvent, error))
            }
        }
        
        guard processingErrors.isEmpty else {
            throw .queueProcessingFailed(processingErrors)
        }
    }
    
    func track(_ event: TrackingEvent) async throws {
        guard isTracking else {
            eventQueue.append(event)
            return
        }
        
        try await forceTrack(event)
    }
    
    private func forceTrack(_ event: TrackingEvent) async throws(Error) {
        do {
            try await configuration.proxy.trackEvent(prepareEvent(from: event))
        } catch {
            throw .eventProcessingFailed(error)
        }
    }
    
    func prepareEvent(from event: TrackingEvent) -> TrackingEvent {
        let transformedEvent = configuration.eventTransformer(event)
        return TrackingEvent(
            transformedEvent.name,
            parameters: parametersPackage(from: transformedEvent.parameters)
        )
    }
    
    private func parametersPackage(from parameters: TrackingEvent.Parameters) -> TrackingEvent.Parameters {
        parameters.mapValues { value in
            guard let stringValue = value as? String, stringValue.count > 100 else { return value }
            return String(stringValue.prefix(99) + "…")
        }
    }
    
}

// MARK: - Error

extension TrackingService {
    
    enum Error: Swift.Error {
        case proxySetupFailed(any Swift.Error)
        case queueProcessingFailed([(queuedEvent: TrackingEvent, processingError: any Swift.Error)])
        case eventProcessingFailed(any Swift.Error)
    }
    
}
