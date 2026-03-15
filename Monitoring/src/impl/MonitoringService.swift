//
//  MonitoringService.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 5/21/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

import Foundation

// MARK: - MonitoringService

final actor MonitoringService {
    
    // MARK: Properties
    
    private let configuration: MonitoringServiceConfiguration
    private let errorReportingService: (any ErrorReportingServiceProtocol)?
    private let loggingService: (any LoggingServiceProtocol)?
    private let trackingService: (any TrackingServiceProtocol)?
    
    // MARK: Initialization
    
    init(
        configuration: MonitoringServiceConfiguration,
        errorReportingService: (any ErrorReportingServiceProtocol)?,
        loggingService: (any LoggingServiceProtocol)?,
        trackingService: (any TrackingServiceProtocol)?
    ) {
        self.configuration = configuration
        self.errorReportingService = errorReportingService
        self.loggingService = loggingService
        self.trackingService = trackingService
    }
    
}

// MARK: - MonitoringServiceProtocol

extension MonitoringService: MonitoringServiceProtocol {
    
    func start() async throws(MonitoringServiceError) {
        let componentErrors = await withTaskGroup(
            of: Optional<(MonitoringComponent, any Error)>.self
        ) { group in
            group.addTask {
                do {
                    try await self.errorReportingService?.start()
                    return nil
                } catch {
                    return (.errorReporting, error)
                }
            }
            group.addTask {
                do {
                    try await self.trackingService?.start()
                    return nil
                } catch {
                    return (.tracking, error)
                }
            }
            
            var errors = [(MonitoringComponent, any Error)]()
            for await result in group {
                if let result {
                    errors.append(result)
                }
            }
            return errors
        }
        
        if !componentErrors.isEmpty {
            throw .failedToStartComponents(componentErrors)
        }
    }
    
    func track(_ event: TrackingEvent) async {
        try? await trackingService?.track(event)
        
        if configuration.logEvents {
            await loggingService?.log(
                for: .custom("YMMonitoring.TrackingService"),
                level: .info,
                "Did track event \(event.name)"
            )
        }
    }
    
    func log(category: String?, level: LogLevel, _ message: String) async {
        let category: LogCategory = if let category { .custom(category) } else { .default }
        await loggingService?.log(for: category, level: level, message)
    }
    
    @available(*, deprecated, renamed: "log(category:level:_:)")
    func log(forCategory category: String, _ message: String) async {
        await log(category: category, level: .default, message)
    }
    
    @available(*, deprecated, renamed: "log(category:level:_:)")
    func log(_ message: String) async {
        await log(category: nil, level: .default, message)
    }
    
    func reportError(_ error: any Swift.Error) async {
        try? await errorReportingService?.reportError(error)
        
        if configuration.logErrors {
            await loggingService?.logError(error, for: .default)
        }
        
        if configuration.trackErrors {
            try? await trackingService?.track(eventFromError(error))
        }
    }
    
    func reportError(_ message: String) async {
        await reportError(ErrorWrapper(message: message))
    }
    
    private func eventFromError(_ error: any Error) -> TrackingEvent {
        TrackingEvent(configuration.eventNameForErrors, parameters: parametersFromError(error))
    }
    
    private func parametersFromError(_ error: any Error) -> TrackingEvent.Parameters {
        let nsError = error as NSError
        return [
            "NSError-Code": nsError.code,
            "NSError-Domain": nsError.domain,
            NSLocalizedDescriptionKey: error.localizedDescription,
        ]
    }
    
}
