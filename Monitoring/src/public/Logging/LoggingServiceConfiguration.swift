//
//  LoggingServiceConfiguration.swift
//  YMMonitoring
//
//  Created by Yakov Manshin on 8/15/20.
//  Copyright © 2020 Yakov Manshin. See the LICENSE file for license info.
//

/// The object used to configure the logging service.
public struct LoggingServiceConfiguration: Sendable {
    
    /// The name of the subsystem that emits log entries.
    let subsystem: String
    
    /// The default category name used to record log entries.
    let defaultCategory: String
    
    public init(subsystem: String, defaultCategory: String) {
        self.subsystem = Self.removeWhitespaces(from: subsystem)
        self.defaultCategory = Self.removeWhitespaces(from: defaultCategory)
    }
    
    private static func removeWhitespaces(from string: String) -> String {
        string.replacingOccurrences(of: #"\s"#, with: "-", options: .regularExpression)
    }
    
}
