//
//  ErrorReportingService.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 5/18/23.
//  Copyright © 2023 Yakov Manshin. See the LICENSE file for license info.
//

// MARK: - ErrorReportingService

final actor ErrorReportingService {
    
    // MARK: Properties
    
    private let configuration: ErrorReportingServiceConfiguration
    
    private(set) var isReporting = false
    private(set) var errorQueue = [any Swift.Error]()
    
    // MARK: Initialization
    
    init(configuration: ErrorReportingServiceConfiguration) {
        self.configuration = configuration
    }
    
}

// MARK: - ErrorReportingServiceProtocol

extension ErrorReportingService: ErrorReportingServiceProtocol {
    
    func start() async throws(Error) {
        do {
            try await configuration.proxy.setUp(with: configuration)
        } catch {
            throw Error.proxySetupFailed(error)
        }
        
        defer { isReporting = true }
        try await processQueuedErrors()
    }
    
    private func processQueuedErrors() async throws(Error) {
        var processingErrors = [(any Swift.Error, Error)]()
        
        while !errorQueue.isEmpty {
            let dequeuedError = errorQueue.removeFirst()
            do {
                try await forceReportError(dequeuedError)
            } catch {
                processingErrors.append((dequeuedError, error))
            }
        }
        
        guard processingErrors.isEmpty else {
            throw .queueProcessingFailed(processingErrors)
        }
    }
    
    func reportError(_ error: any Swift.Error) async throws(Error) {
        guard isReporting else {
            errorQueue.append(error)
            return
        }
        
        try await forceReportError(error)
    }
    
    private func forceReportError(_ error: any Swift.Error) async throws(Error) {
        do {
            try await configuration.proxy.reportError(error)
        } catch {
            throw .errorProcessingFailed(error)
        }
    }
    
}

// MARK: - Error

extension ErrorReportingService {
    
    enum Error: Swift.Error {
        case proxySetupFailed(any Swift.Error)
        case queueProcessingFailed([(queuedError: any Swift.Error, processingError: any Swift.Error)])
        case errorProcessingFailed(any Swift.Error)
    }
    
}
