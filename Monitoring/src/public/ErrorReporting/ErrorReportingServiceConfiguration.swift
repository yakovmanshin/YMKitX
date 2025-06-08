//
//  ErrorReportingServiceConfiguration.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 5/24/25.
//  Copyright © 2025 Yakov Manshin. See the LICENSE file for license info.
//

// MARK: - Configuration

/// The object used to configure the error-reporting service.
public struct ErrorReportingServiceConfiguration: Sendable {
    
    /// The proxy object.
    let proxy: any Proxy
    
    public init(proxy: any Proxy) {
        self.proxy = proxy
    }
    
}

// MARK: - Proxy

extension ErrorReportingServiceConfiguration {
    
    /// The proxy object that handles the error-reporting service’s requests.
    public protocol Proxy: Sendable {
        func setUp(with configuration: ErrorReportingServiceConfiguration) async throws
        func reportError(_ error: any Error) async throws
    }
    
}
